#! /bin/bash -f

clean_up() { # Perform pre-exit housekeeping
  return
}

error_exit() {
  echo -e "${PROGNAME}: ${1:-"Unknown Error"}" >&2
  clean_up
  exit 1
}

usage() {
  echo "Usage: ${0##*/} log-file"
}

if [ $# -eq 1 ]; then
  logfile=$1
  tmpfile=$1.tmp
  if [ ! -f ${logfile} ]; then
    echo "${logfile} is not found."
    exit 1
  fi
  if [ -f ${tmpfile} ]; then
    echo "Delete existing ${tmpfile}"
    rm ${tmpfile}
  fi
  echo "Cleansing..."
  # grep -v 'MAT\|message' ${logfile} | cut -d ' ' -f 2-4 > ${tmpfile}
  grep -v 'MAT\|message' ${logfile} > ${tmpfile}
  mv ${tmpfile} ${logfile}
  #
  bname=$(basename ${logfile})
  prename=${bname%.*}
  extname=${bname##*.}
  zipname=$prename.zip
  md5name=$prename.md5
  zip ${zipname} ${logfile}
  md5sum ${zipname} > ${md5name}
  wc ${logfile} >> ${md5name}
  #
  cp ${zipname} ${md5name} /mnt/work1/opt/git/box1
else
  usage
fi
