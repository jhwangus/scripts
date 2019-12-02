#!/bin/csh -f
set topdir=${cwd}
foreach dir (TLDR_SRAM*)
   cd ${topdir}
   echo $dir
   cd $dir
   source Build-Platform-tracer.sh
   ./run_tracerVP ../12K.log > ../t28.log
   # ./run_tracerVP ../12K.log
end
