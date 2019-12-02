#!/bin/csh -f
set topdir=${cwd}
foreach dir (TLDR_SRAM*)
   echo $dir
   set ac=`echo $dir | tr "[:upper:]" "[:lower:]" | sed 's/tldr_//'`
   echo ${ac}
   save_plot.py ${dir}/1130_12k_${ac}.csv 2 12 1130_12k_r_${ac}
   save_plot.py ${dir}/1130_12k_${ac}.csv 3602 12 1130_12k_rw_${ac}
end
