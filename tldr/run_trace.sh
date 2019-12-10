#!/bin/bash
# ---------------------------------------------------------------------------
# run_trace.sh - Feed memory traces into Traffic Loader

# Copyright 2019, Jack Hwang,,, <jhwangzd@DSC81>
# All rights reserved.

# Usage: run_trace.sh [-h|--help] dir

# Revision history:
# 2019-11-04 Created by new_script ver. 3.3
# ---------------------------------------------------------------------------

PROGNAME=${0##*/}
VERSION="0.1"

clean_up() { # Perform pre-exit housekeeping
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
  echo -e "Usage: $PROGNAME [-h|--help] dir"
}

help_message() {
  cat <<- _EOF_
  $PROGNAME ver. $VERSION
  Feed memory traces into Traffic Loader

  $(usage)

  Options:
  -h, --help  Display this help message and exit.
  dir         Directory with trace logs

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
      trace_dir=$1; break ;;
  esac
  shift
done

# Main logic

if [ ! -d ${trace_dir} ]; then
  echo -e "${trace_dir} does not exist" >&2
  graceful_exit
fi

ALL_RPT=../all_reports
if [ -d ${ALL_RPT} ]; then
  echo -e "${ALL_RPT} exists.  Rename it or remove it."
  graceful_exit
else
  mkdir ${ALL_RPT}
fi

for f in ${trace_dir}/*.log
do
  tname=$(basename $f)
  trpt=${ALL_RPT}/${tname%.*}
  
  echo '====================='
  echo ${tname}
  ./run_tracerVP $f

  echo "Copy ../Report to ${trpt}"
  mkdir ${trpt}
  cp -r ../Report ${trpt}
done

graceful_exit

