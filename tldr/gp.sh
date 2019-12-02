#! /bin/bash -f
if [ $# -eq 1 ]; then
  bname=$(basename ${1})
  prename=${bname%.*}
  extname=${bname##*.}
  md5name=$prename.md5
  #
  if [ -f ${1} ]; then
    split -b 20m ${1} ${prename}_
    for f in ${prename}_??
    do
      echo ${f}
      git add $f
      git commit -m "splitfile"
    done
  else
     echo "File ${1} does not exist"
     exit 1
  fi
  #
  if [ -f $md5name ]; then
    git add $md5name
    git commit -m "md5"
  fi
else
  echo "Usage: ${0##*/} file"
fi
