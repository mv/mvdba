#!/bin/bash
# $Id$
# Dez/2007


[ "$1" ] || {
    echo
    echo "    Usage: $0 <dirs> "
    echo
    exit 2
}

MYDIR=$PWD

for trace in `find "$@" -type d `
do

    echo "Trace: $trace"

    cd $MYDIR/$trace
    count=0
    for file in *trc
    do
        (( count++ ))
        echo "    Trace: ${trace}_${count}"
        tkprof $file ${trace}_${count}.txt
        tkprof $file ${trace}_${count}_explain.txt          explain=apps/apps@gaudi
        tkprof $file ${trace}_${count}_explain_sysno.txt    explain=apps/apps@gaudi sys=no

        for sort in prscnt prscpu prsela prsdsk prsqry prscu prsmis execnt execpu exeela exedsk exeqry execu exerow exemis fchcnt fchcpu fchela fchdsk fchqry fchcu fchrow userid
        do

            echo "    Trace: ${trace}_${count}_${sort}.txt"
          # tkprof $file  ${trace}_${count}_${sort}.txt                           sort=$sort
          # tkprof $file  ${trace}_${count}_sysno_${sort}.txt            sys=no   sort=$sort
          # tkprof $file  ${trace}_${count}_explain_${sort}.txt          explain=apps/apps@gaudi sort=$sort
          # tkprof $file  ${trace}_${count}_explain_sysno_${sort}.txt    explain=apps/apps@gaudi sys=no sort=$sort

        done # for sort

    done # for file

done # for dir

