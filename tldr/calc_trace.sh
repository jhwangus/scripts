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
  echo "Usage: ${0##*/} secs"
  echo "       secs - seconds"
}

SYSLOG_FILE=mat.log

if [ $# -eq 1 ]; then
  elapse_time=$1
  st=`wc -l < $SYSLOG_FILE`
  sleep $elapse_time
  se=`wc -l < $SYSLOG_FILE`
  let th=(se-st)/$elapse_time
  let len=(100000000/$th)
  echo "$st - $se lines"
  echo "$elapse_time seconds"
  echo "$th lines/sec"
  echo "$len seconds for 100M mem access"
else
  usage
fi
