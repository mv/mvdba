#!/bin/bash
# $Id: adp.sh 19509 2007-10-24 17:12:45Z marcus.ferreira $
# $URL: http://mdbebsfsw2.mdb.com.br:8080/repos/salto/trunk/atg/adpatch/adp.sh $
# defaults de adpatch: desenv
#
# (c) Marcus Vinicius Ferreira [ferreira.mv at gmail.com] Ago/2006
#

usage() {
    cat <<CAT

    Usage: $0 <drive_name> [<adpatch options>]

CAT
    exit 1
}

[ -f "$1" ] || usage

# Names
PATCH=${1%.*}
PATCH_DRV=$1
PATCH_LOG=${PATCH}.adpatch.output.log

# AD default
       SID=`echo $CONTEXT_NAME | awk -F_ '{print $1}'`
AD_DEFAULT="${APPL_TOP}/admin/$SID/ad.defaults.${CONTEXT_NAME}.txt"
      LOGS="${APPL_TOP}/admin/$SID/log"

touch $AD_DEFAULT

# logs
for f in $LOGS/adpatch.lgi $LOGS/adpatch.log $LOGS/adwork*.log
do
    tail -1f $f > ${PATCH}.${f##*/} &
done

# exec
adpatch \
    defaultsfile=$AD_DEFAULT                        \
    logfile=adpatch.log                             \
    patchtop=$PWD driver=$PATCH_DRV                 \
    workers=1                                       \
    options=noprereq,novalidate,norevcache,hotpatch \
    2>&1 | tee $PATCH_LOG

#   options=noprereq,novalidate,norevcache,hotpatch,actiondetails \
#   flags=trace                                     \
#   egrep -v "^\s*$" $PATCH_LOG | cat -n >> ./$PATCH_LOG

# Remove child 'tail'
{
    kill `ps -f | grep "tail -1f ${LOGS}" | grep -v grep | awk '{print $2}' ` 
} 2>/dev/null

# Bkp
/bin/cp ${PATCH}.ad* $LOGS/

# End
echo
echo "Defaults: [ $AD_DEFAULT ]"
echo

exit 0

