#!/bin/csh -f
set topdir=${cwd}
foreach dir (TLDR_SRAM*)
   cd ${topdir}
   cd $dir/build
   
   # Run 1.5M
   set ac=1130_st_`echo $dir | tr "[:upper:]" "[:lower:]" | sed 's/tldr_//'`
   echo ${ac}
   (run_trace.sh /mnt/work1/s2k_log/1.5M > ../${ac}.log; proc_trace_sum.sh ../${ac}.log; cp ../${ac}.csv ${topdir}/perf) &
   # proc_trace_sum.sh ../${ac}.log
   # cp ../${ac}.csv ${topdir}/perf

   # Run 12K
   #set ac=1130_12k_`echo $dir | tr "[:upper:]" "[:lower:]" | sed 's/tldr_//'`
   #./run_tracerVP ../12K.log > ../t30.log
   #trace_time.sh ../t30.log ../${ac}.csv
   #cp ../${ac}.csv ${topdir}
end
