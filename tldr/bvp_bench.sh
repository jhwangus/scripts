#! /bin/bash -f
#
# This script waits for the appearance of name.token and start_bench.token
#    1. Start the benchmark in the name.token
#    2. after 10 seconds, start the dump
# Then it waits for the appearance of stop_bench.token
#    1. Kill the current bench
# Goto top to wait for another bench
# If got an exit_bench.token, then exit the script

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

SCRIPT_PATH=./spec2000/aarch64-cpu2000-1.3.1
SETSIM=./setsim
START_TOK=start_bench.token
END_TOK=end_bench.token
EXIT_TOK=exit_bench.token
NAME_TOK=name.token
current_job=0

# State machine
#   idle --> run | exit, the other two no actions
#   run --> stop_trace | stop | exit
#   stop_trace  --> stop | exit
#   stop --> idle | exit
#   exit
state="idle"
while true; do
  case "$state" in
  "idle")
    echo "idle state"
    if [ -f ${START_TOK} ]; then
      rm ${START_TOK}
      if [ -f ${NAME_TOK} ]; then
        read -r bench_name < ${NAME_TOK}
        rm ${NAME_TOK}
        echo "starting ${bench_name}"
        # ${SCRIPT_PATH}/${bench_name}.sh &
        echo ${SCRIPT_PATH}/${bench_name}.sh &
        current_job=$!
        sleep 5
        # ${SETSIM} 1
        echo ${SETSIM} 1
        state="run"
      else
        echo "Cannot find name.token file."
      fi
    elif [ -f ${END_TOK} ]; then
      echo "Invalid token \"${END_TOK}\" at state \"$state\""
      rm ${END_TOK} 
    elif [ -f ${EXIT_TOK} ]; then
      break
    fi
    sleep 60  
    ;; 
  "run")       
    echo "run state"
    if [ -f ${END_TOK} -o -f ${EXIT_TOK} ]; then
      # ${SETSIM} 0
      echo ${SETSIM} 0
      sleep 5
      kill -9 ${current_job}
      current_job=0
      sleep 10
      rm ${END_TOK}
      state=”idle“
    fi
    if [ -f ${EXIT_TOK} ]; then
      break
    elif [ -f ${START_TOK} ]; then
      echo "Invalid token \"${EXIT_TOK}\" at state \"$state\"" 
      rm ${START_TOK}}
      if [ -f ${NAME_TOK} ]; then
        rm ${NAME_TOK}
      fi
    fi
    sleep 60
    ;;
  *)
    echo "invalid state \"$state\""
    break
    ;;
  esac
done

#exit
if [ ${current_job} -ne 0 ]; then
  echo "Kill process ${current_job}"
  kill -9 ${current_job}
  current_job=0
fi

rm ${EXIT_TOK}
