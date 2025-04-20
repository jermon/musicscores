#!/bin/bash

#define parameters which are passed in.
basename=`grep basename: index.html | cut -d' ' -f2`
#define the template.
cat >job.json << EOF
[
  {
    "in": "${basename}.mscz",
    "out": [
      "${basename}.pdf",
      "${basename}.svg",
      "${basename}.mp3",
      "${basename}.mpos",
      "${basename}.xml",
      [ "${basename}-", ".pdf" ],
      [ "${basename}-", ".svg" ],
      [ "${basename}-", ".mp3" ]
    ]
  }
]
EOF