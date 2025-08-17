#!/bin/bash

set -euo pipefail

# --- Usage ---
# ./generate_indexfile.sh <file.mscz>
#
# This script generates a Jekyll front matter file from a MuseScore (.mscz) file.
# It uses xmlstarlet for robust parsing of the .mscx file contained within.

# --- Requirements ---
# - unzip
# - xmlstarlet

# --- Check for dependencies ---
for cmd in unzip xmlstarlet; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' is not installed." >&2
        exit 1
    fi
done

# --- Input validation ---
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file.mscz>" >&2
    exit 1
fi

mscz_file="$1"

if [ ! -f "$mscz_file" ]; then
    echo "Error: File not found: $mscz_file" >&2
    exit 1
fi

# --- Metadata extraction ---
basename="${mscz_file%.*}"
title=$(basename "$basename" | tr '_' ' ')

# Unzip the .mscz file in memory and pipe the .mscx content to xmlstarlet
# The '*.mscx' pattern must be quoted to prevent shell expansion.
mscx_content=$(unzip -p "$mscz_file" '*.mscx' 2>/dev/null)

if [ -z "$mscx_content" ]; then
    echo "Error: Could not extract .mscx file from $mscz_file" >&2
    exit 1
fi

# Use xmlstarlet to select the metadata, then sort parts according to a predefined order
all_parts=$(echo "$mscx_content" | xmlstarlet sel -t -v "//metaTag[@name='partName']" -n | sort -u || true)
desired_order=("Voice" "Soprano" "Mezzo-soprano" "Alto" "Contralto" "Countertenor" "Tenor" "Baritone" "Bass")


# Grab parts that are in the desired order list, in that order
ordered_parts_string=""
for part in "${desired_order[@]}"; do
    if echo "$all_parts" | grep -q -x -F "$part"; then
        ordered_parts_string+="$part\n"
    fi
done


# Grab the remaining parts (sorted alphabetically) and append them
remaining_parts=$(echo "$all_parts" | grep -v -x -F -f <(printf "%s\n" "${desired_order[@]}") || true)


# Combine the lists into the final 'parts' variable
parts=$(echo -e "${ordered_parts_string}${remaining_parts}" | sed '/^$/d')

categories=$(echo "$mscx_content" | xmlstarlet sel -t -v "//metaTag[@name='categories']" || true)

tags=$(echo "$mscx_content" | xmlstarlet sel -t -v "//metaTag[@name='tags']" -n | sort -u)

thumbnail=$(echo "$mscx_content" | xmlstarlet sel -t -v "//metaTag[@name='thumbnail']" || true)


# --- Template generation ---
cat << EOF
---
layout: notepage
title: "${title}"
basename: "${basename}"
categories: ${categories:-general}
tags:
EOF

if [ -n "$tags" ]; then
    while IFS= read -r tag; do
        echo "  - ${tag}"
    done <<< "$tags"
fi

echo "thumbnail: \"${thumbnail}\""
echo "parts:"

if [ -n "$parts" ]; then
    while IFS= read -r part; do
        echo "  - \"${part}\""
    done <<< "$parts"
fi

echo "---"
