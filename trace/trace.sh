#!/bin/bash
# $Id$
# Dez/2007


[ "$1" ] || {
    echo
    echo "    Usage: $0 <files> "
    echo
    exit 2
}

for trace in $@
do

    echo "Trace: $trace"

    tkprof $trace ${trace}.txt
#   tkprof $trace ${trace}_sysno.txt         sys=no
    tkprof $trace ${trace}_explain.txt               explain=apps/apps@gaudi
    tkprof $trace ${trace}_explain_sysno.txt sys=no  explain=apps/apps@gaudi
    chmod 664 ${trace}*.txt

done # for dir

