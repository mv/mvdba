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
        tkprof $file ${trace}_${count}_explain_sysno.txt    explain=apps/apps@gaudi sys=no

    done # for file

done # for dir

