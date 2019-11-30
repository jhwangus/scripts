#! /bin/bash
# ---------------------------------------------------------------------------
# trace_time.sh - post processing the detail trace dump to get timing info

# Copyright 2019, Jack Hwang,,, <jhwangzd@DSC81>
# All rights reserved.

# Usage: trace_time.sh [-h|--help] log_file csv_file

# Revision history:
# 2019-11-04 Created by new_script ver. 3.3
# ---------------------------------------------------------------------------

PROGNAME=${0##*/}
VERSION="0.1"

clean_up() { # Perform pre-exit housekeeping
  if [ -f temp.log ]; then
    # rm temp.log
    echo temp.log
  fi
  return
}

error_exit() {
  echo -e "${PROGNAME}: ${1:-"Unknown Error"}" >&2
  clean_up
  exit 1
}

graceful_exit() {
  clean_up
  exit
}

signal_exit() { # Handle trapped signals
  case $1 in
    INT)
      error_exit "Program interrupted by user" ;;
    TERM)
      echo -e "\n$PROGNAME: Program terminated" >&2
      graceful_exit ;;
    *)
      error_exit "$PROGNAME: Terminating on unknown signal" ;;
  esac
}

usage() {
  echo -e "Usage: $PROGNAME [-h|--help] log_file csv_file"
}

help_message() {
  cat <<- _EOF_
  $PROGNAME ver. $VERSION
  Feed memory traces into Traffic Loader

  $(usage)

  Options:
  -h, --help  Display this help message and exit.
  log_file    Input log file
  csv_file    Ouput csv file

_EOF_
  return
}

# Trap signals
trap "signal_exit TERM" TERM HUP
trap "signal_exit INT"  INT

# Parse command-line
while [[ -n $1 ]]; do
  case $1 in
    -h | --help)
      help_message; graceful_exit ;;
    -* | --*)
      usage
      error_exit "Unknown option $1" ;;
    *)
      log_file=$1; csv_file=$2; break ;;
  esac
  shift
done

# Main logic

if [ ! -f ${log_file} ]; then
  echo -e "${trace_dir} does not exist" >&2
  graceful_exit
fi

grep "Start cmd\|End cmd\|Data txn\|Line" ${log_file} | sed \
    's/Line: 0 | /Read  [/; s/Line: 1 | /Write [/; s/ | 0 | /] [/; s/ns$/ns]/' > temp.log
    
trace_time.py temp.log > temp.csv

head -1 temp.csv > ${csv_file}
tail -n+2 temp.csv | sort -n -k7 >> ${csv_file}

graceful_exit





