#!/bin/bash
#
# Clean ocr backup files
#
# Marcus Vinicius Ferreira
# 2009/10

# PATH sample
PATH=/opt/csw/bin:opt/csw/sbin
PATH=$PATH:/opt/local/bin:/opt/local/sbin
PATH=$PATH:/usr/local/bin:/usr/local/sbin
PATH=$PATH:/usr/bin:/usr/sbin:/bin:/sbin

[ "$1" != "-f" ] && {
cat <<CAT

Usage: $0 -f

    Clean ocr backup files

CAT
exit 1
}

LOG_DIR=/u01/app/oracle/log

### Setup
. /u01/app/oracle/bin/env-ora.sh
MAIL_TO="marcus.ferreira@abril.com.br"

# Log {
[ -z $LOG_DIR ] && LOG_DIR=/tmp
LOG=${LOG_DIR}/${0##*/}.log


# Auto-rotate, if log > 5Mb
touch $LOG
size=$( /bin/ls -l $LOG | awk '{print $5}' ) # size bytes
[ $size -gt 5242880 ] && > $LOG              # 5000k, 5m
# }

# No terminal: all output to $LOG (script running via cron)
if ! tty -s
then exec 1 >> $LOG ; exec 2 >> $LOG
fi

logmsg() {
    if tty -s
    then echo "$( date '+%Y-%m-%d %X'): $1" | tee -a $LOG
    else echo "$( date '+%Y-%m-%d %X'): $1"
    fi
}

# email
emailmsg() {
    subject="$(hostname) - $0"
    mail -s "$subject - $1" $MAIL_TO <<MAIL
From: no-reply@oracle
To: $MAIL_TO
Subject: $subject - $1

Log: $LOG
________________________________________________________________________

$( cat -n $LOG | tail -15 )
________________________________________________________________________

MAIL
}

###
### Main
###
SRC_DIR=/u01/app/oracle/product/10.2.0/crs_1/cdata/crs_ABDPS
DST_DIR=/backup/CLUSTER/crs-cdata-abdps1

cd $SRC_DIR
logmsg "Compress old files"
find . -type f -name '[0-9]*'   -mtime +5 -ls -exec gzip -v {} \;

logmsg "Moving... to $DST_DIR"
find . -type f -name '[0-9]*gz'           -ls -exec mv {} $DST_DIR \;

logmsg "END"

emailmsg "Cleanup $SRC_DIR"

