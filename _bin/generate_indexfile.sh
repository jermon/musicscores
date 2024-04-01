#!/bin/bash

#define parameters which are passed in.
basename=${1%.*}
title=`echo $basename | tr _ " "`
parts=`unzip -c ${basename}.mscz | grep '<metaTag name="partName">' | cut -d'>' -f2 | cut -d'<' -f1 | sort -u`
categories=`unzip -c ${basename}.mscz |grep '<metaTag name="categories">'|cut -d'>' -f2|cut -d'<' -f1|sort -u`
categories=${categories:=general}
tags=`unzip -c ${basename}.mscz |grep '<metaTag name="tags">'|cut -d'>' -f2|cut -d'<' -f1|sort -u`
tumbnail=`unzip -c ${basename}.mscz |grep '<metaTag name="tumbnail">'|cut -d'>' -f2|cut -d'<' -f1|sort -u`

#define the template.
cat  << EOF
---
layout: default
title: ${title}
basename: ${basename}
categories: ${categories}
tags:
EOF

for tag in $tags 
do
  echo "  - " $tag
done

echo "tumbnail: " $tumbnail
echo "parts:"

for part in $parts 
do
  echo "  - " $part
done

cat  << EOF
---

{% include mscweb.html %}

EOF