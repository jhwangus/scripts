#! /bin/bash -f

base_path=/mnt/work1/opt/spec2000
work_path=/opt/NNSim/data_1114/work1/opt/spec2000

clean_up() { # Perform pre-exit housekeeping
  return
}

error_exit() {
  echo -e "${PROGNAME}: ${1:-"Unknown Error"}" >&2
  clean_up
  exit 1
}

usage() {
  echo "Usage: ${0##*/} [1|2] file"
  echo "       1 - move mnt cpu2000 to aarch64-cpu2000"
  echo "       2 - move mnt aarch64-cpu2000 to data_1114"
}

copy_file () {
  echo "copying..."
  cd ${src_path}
  for f in $(find . -name ${fname});  do
    if [[ -d $(dirname ${src_path}/$f) && -d $(dirname ${dest_path}/$f) ]]; then
      echo ${src_path}/$f
      cp ${src_path}/$f ${dest_path}/$f
    else
      echo "No $(dirname ${src_path}/$f) or $(dirname ${dest_path}/$f)"
    fi
  done
}

if [ $# -eq 2 ]; then
  func=$1
  fname=$2
  if [ ${func} -eq '1' ]; then
    src_path=${base_path}/cpu2000-1.3.1
    dest_path=${base_path}/aarch64-cpu2000-1.3.1
    copy_file
  elif [ ${func} -eq '2' ]; then
    src_path=${base_path}/aarch64-cpu2000-1.3.1
    dest_path=${work_path}/aarch64-cpu2000-1.3.1
    copy_file
  else
    usage
  fi
else
  usage
fi
