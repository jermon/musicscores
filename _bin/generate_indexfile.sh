#!/bin/bash

#define parameters which are passed in.
basename=${1%.*}
title=`echo $basename | tr _ " "`
parts=`unzip -c ${basename}.mscz | grep '<metaTag name="partName">' | cut -d'>' -f2 | cut -d'<' -f1 | sort -u`
categories=`unzip -c ${basename}.mscz |grep '<metaTag name="categories">'|cut -d'>' -f2|cut -d'<' -f1|sort -u`
categories=${categories:=general}
tags=`unzip -c ${basename}.mscz |grep '<metaTag name="tags">'|cut -d'>' -f2|cut -d'<' -f1|sort -u`
thumbnail=`unzip -c ${basename}.mscz |grep '<metaTag name="thumbnail">'|cut -d'>' -f2|cut -d'<' -f1|sort -u`

#define the template.
cat  << EOF
---
layout: notepage
title: ${title}
basename: ${basename}
categories: ${categories}
tags:
EOF

for tag in $tags 
do
  echo "  - " $tag
done

echo "thumbnail: \""$thumbnail"\""
echo "parts:"

for part in $parts 
do
  echo "  - " $part
done
echo "---"
