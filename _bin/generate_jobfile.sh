#!/bin/bash

#define parameters which are passed in.
# basename=$1

indexfiles=`find . -name index.html|grep -v "^./index.html"`
for f in $indexfiles
do
#basename=`dirname ${f} |cut -c 3-`
basename=`grep basename: ${f} |cut -d' ' -f2`
#define the template.
cat >`dirname ${f}`/job.json << EOF
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
done

