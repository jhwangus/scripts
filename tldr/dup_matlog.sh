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
  if [ ! -f mat.log ]; then
    echo "mat.log is not found."
    exit 1
  elif [ -e $logfile ]; then
    echo "Error: $logfile exists!"
  else
    cp mat.log $logfile && sudo cp /dev/null mat.log && sudo service rsyslog restart
    ls -lS $logfile mat.log
  fi
else
  usage
fi
