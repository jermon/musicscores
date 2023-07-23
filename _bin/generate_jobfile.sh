#!/bin/bash

#define parameters which are passed in.
basename=$1


#define the template.
cat  << EOF
[
  {
    "in": "${basename}.mscz",
    "out": [
      "${basename}.svg",
      "${basename}.mp3",
      "${basename}.mpos",
      "${basename}.xml",
      [ "${basename}-", ".svg" ],
      [ "${basename}-", ".mp3" ]
    ]
  }
]
EOF

