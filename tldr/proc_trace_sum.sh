#!/bin/bash
# ---------------------------------------------------------------------------
# proc_trace_sum.sh - Process the trace summary reports

# Copyright 2019, Jack Hwang,,, <jhwangzd@DSC81>
# All rights reserved.

# Usage: proc_trace_sum [-h|--help] file

# Revision history:
# 2019-11-06 Created by new_script ver. 3.3
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
  echo -e "Usage: $PROGNAME [-h|--help] file"
}

help_message() {
  cat <<- _EOF_
  $PROGNAME ver. $VERSION
  Process the trace summary report

  $(usage)

  Options:
  -h, --help  Display this help message and exit.
  file        Trace summary report file

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
      sum_fname=$1; break ;;
  esac
  shift
done

# Main logic

if [ ! -f ${sum_fname} ]; then
  echo -e "${sum_fname} does not exist" >&2
  graceful_exit
fi

csvfile=${sum_fname%.*}'.csv'

echo '"Benchmarks","# of Traces","Time (sec)","Traces/sec","Sim Time (ns)","Sim Time ns/trace"' > ${csvfile}

#grep 'log\|traces\|used\|Length' ${sum_fname} | sed \
#    's/ seconds//; s/ traces\/sec//; s/=/:/; s/ ns//' | \
#    sed 's/^.* : //' | awk '{printf "%s" (NR%5==0?RS:FS),$1}' | \
#    sed 's/\.log//; s/ /,/g' >> ${csvfile}

grep 'log\|traces\|used\|Length' ${sum_fname} | sed \
    's/ seconds//; s/ traces\/sec//; s/=/:/' |sed 's/^.* : //' | \
    awk '{if ($0 ~ / ps/) {print int($1/1000)} else {print $0}}' | \
    awk '{printf "%s" (NR%5==0?RS:FS),$1}' | sed 's/\.log//; s/ /,/g' >> ${csvfile}




graceful_exit

