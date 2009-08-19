#!/bin/bash
#
# Format mysql slow-query log
#
# Marcus Vinicius Ferreira                      ferreira.mv[ at ]gmail.com
# 2009-08
#

[ -z "$1" ] && {

    echo
    echo "    Usage: $0 <file> "
    echo
    exit 1

}

[ -f "$1" ] || {
    echo
    echo "Error: [$1] is NOT a file...."
    echo
    exit 2
}

set -x
mysqldumpslow -s at "$1" > ${1}.avgtime.txt
mysqldumpslow -s  t "$1" > ${1}.time.txt
mysqldumpslow -s al "$1" > ${1}.avglock.txt
mysqldumpslow -s  l "$1" > ${1}.lock.txt
mysqldumpslow -s ac "$1" > ${1}.avgcountrows.txt
mysqldumpslow -s  c "$1" > ${1}.countrows.txt

set +x
for f in ${1}.{count,lock,time}*txt;
do
    echo
    echo $f
    echo --------------------------------------------------------
    cat -n $f | head -20
done > ${1}.resume.txt

for f in ${1}.avg{count,lock,time}*txt;
do
    echo
    echo $f
    echo --------------------------------------------------------
    cat -n $f | head -20
done > ${1}.avgresume.txt

