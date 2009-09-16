#!/bin/bash
# $Id: break.p.sh 4568 2006-11-24 00:11:48Z marcus.ferreira $
#
# brute force parallel recomp
# Marcus Vinicius Ferreira      ferreira.mv[  at  ]gmail.com
#
# Nov/2006

[ "$#" != "4" ] && exit 1

TP=$1
SPOOL=$2
PARTS=$3
QTD=$4

[ -s $SPOOL ] || {
    echo
    echo "Spool file: size ZERO"
    exit 3
}

# Break on
[ -d $TP ] || mkdir $TP
split -a 4 -l $QTD $SPOOL $TP/${PARTS}.sql.

# Generate "sessions"
for f in $TP/${PARTS}*
do
    echo "sqlplus -s apps/apps <<SQL"    > ${f}.cmd
    echo "set echo on"                  >> ${f}.cmd
    echo "set timing on"                >> ${f}.cmd
    echo "set time on"                  >> ${f}.cmd
    echo "@$f "                         >> ${f}.cmd
    echo "SQL"                          >> ${f}.cmd
done


# Callers in background
for f in $TP/${PARTS}*cmd; do echo " ./$f & " >> ${PARTS}.sh; done

# Clean-up
for f in $TP/${PARTS}*; do echo "/bin/rm $f" >> rm_${PARTS}.sh ; done
echo "/bin/rm rm_${PARTS}.sh " >> rm_${PARTS}.sh
echo "/bin/rm    ${PARTS}.sh " >> rm_${PARTS}.sh


# Callers in background
# perl -pi -e 's{^}{./}; s{$}{  \&};' ${TP}.$$.sh

chmod 755 *sh $TP/*cmd
echo
echo "Done..."
echo "./${PARTS}.sh"
echo "exec ./${PARTS}.sh"
