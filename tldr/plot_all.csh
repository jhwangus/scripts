#!/bin/csh -f
set topdir=${cwd}
foreach dir (TLDR_SRAM*)
   echo $dir
   set ac=`echo $dir | tr "[:upper:]" "[:lower:]" | sed 's/tldr_//'`
   echo ${ac}
   save_plot.py ${dir}/1209_1krw_dep_${ac}.csv 2 16 1209_1krw_r_dep_${ac}
   save_plot.py ${dir}/1209_1krw_dep_${ac}.csv 17 16 1209_1krw_rw_dep_${ac}
end
