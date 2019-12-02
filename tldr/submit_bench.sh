#! /bin/bash -f
#
# This script takes a list of benchmark progs in nnn.sh and nnnmmmm format
#   and iterate through them
# For each of of the benchmark, it does:
#   Create name.token
#   Create start_bench.token
#   wait 200 seconds
#   Enter run mode
#   

clean_up() { # Perform pre-exit housekeeping
  return
}

error_exit() {
  echo -e "${PROGNAME}: ${1:-"Unknown Error"}" >&2
  clean_up
  exit 1
}

usage() {
  echo "Usage: ${0##*/}"
}

SCRIPT_PATH=~/bin
DATA_PATH=/opt/NNSim/data_1114/work1/opt/
START_TOK=${DATA_PATH}/start_bench.token
END_TOK=${DATA_PATH}/end_bench.token
EXIT_TOK=${DATA_PATH}/exit_bench.token
NAME_TOK=${DATA_PATH}/name.token
SYSLOG_FILE=mat.log
#MAX_LINE=10000000
MAX_LINE=10

benches=(255vortex)

for bn in ${benches[@]}; do
  echo "Starting ${bn}"
  log_file=mat_${bn}.log
  echo ${bn:0:3} > ${NAME_TOK}
  touch ${START_TOK}
  # sleep 60
  sleep 1
  echo "Waiting for ${SYSLOG_FILE} has more than ${MAX_LINE} lines"
  # Wait till mat.log is bigger than 100M lines
  while true; do
    si=$(stat --format=%s ${SYSLOG_FILE})
    let lnum=$si/26
    if [ "${lnum}" -gt ${MAX_LINE} ]; then
      echo "End bench ${bn}"
      touch ${END_TOK}
      # sleep 120
      sleep 1
      echo "Post processing ${SYSLOG_FILE}"
      echo ${SCRIPT_PATH}/dup_matlog.sh ${log_file}
      echo ${SCRIPT_PATH}/clean_matlog.sh ${log_file}
      # sleep 60
      sleep 1
      break
    else
      # sleep 300
      sleep 1
    fi
  done
done

touch ${EXIT_TOK}
