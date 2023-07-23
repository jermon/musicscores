#!/bin/bash

#define parameters which are passed in.
basename=$1
title=`echo $basename | tr _ " "`

#define the template.
cat  << EOF
---
layout: default
title: ${title}
basename: ${basename}
parts:
  - Soprano
  - Alto
  - Tenor
  - Bass

---

{% include mscweb.html %}

EOF

