#!/bin/csh -f
set topdir=${cwd}
foreach dir (TLDR_SRAM*)
   cd ${topdir}
   cd $dir/build
   
   # Run 1.5M
   # set ac=1209_1d5m_dep_`echo $dir | tr "[:upper:]" "[:lower:]" | sed 's/tldr_//'`
   # echo ${ac}
   # (run_trace.sh /mnt/work1/s2k_log/1.5M > ../${ac}.log; proc_trace_sum.sh ../${ac}.log; cp ../${ac}.csv ${topdir}/perf) &
   # proc_trace_sum.sh ../${ac}.log
   # cp ../${ac}.csv ${topdir}/perf

   # Run 12K
   # set ac=1209_12k_dep_`echo $dir | tr "[:upper:]" "[:lower:]" | sed 's/tldr_//'`
   # ./run_tracerVP ../12K.log > ../t1209_12k_dep.log
   # trace_time.sh ../t1209_12k_dep.log ../${ac}.csv
   # cp ../${ac}.csv ${topdir}

   # Run 1KRW
   # set ac=1209_1krw_dep_`echo $dir | tr "[:upper:]" "[:lower:]" | sed 's/tldr_//'`
   # ./run_tracerVP ../../1KRW.log > ../t1209_1krw_dep.log
   # trace_time.sh ../t1209_1krw_dep.log ../${ac}.csv
   # cp ../${ac}.csv ${topdir}
   
   # Copy 1KRW
   set ac=1209_1krw_dep_`echo $dir | tr "[:upper:]" "[:lower:]" | sed 's/tldr_//'`
   cp ../t1209_1krw_dep.log ${topdir}/pack/${ac}.log
   # trace_time.sh ../t1209_1krw_dep.log ../${ac}.csv
   # cp ../${ac}.csv ${topdir}
end
