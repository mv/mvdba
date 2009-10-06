#!/bin/bash
#
# QBG: Clean archive logs from FRA
#
#     must be executed once a week
#         00 04 * * 2 /path/cron-rm-archive.sh -f
#
# Marcus Vinicius Ferreira                          ferreira.mv[ at ]gmail.com
# 2009/10

[ "$1" != "-f" ] && {
    echo
    echo "Usage: $0 -f"
    echo
    echo "    Remove archive logs from FRA"
    echo
    exit 1
}

### Setup
. /u01/app/oracle/bin/env-ora.sh

MAIL_TO="marcus.ferreira@abril.com.br"

# Log
[ -z $LOG_DIR ] && LOG_DIR=/tmp
LOG=${LOG_DIR}/${0##*/}.log
touch $LOG

# Auto-rotate
size=$( /bin/ls -l $LOG | awk '{print $5}' ) # size bytes
[ $size -gt 5242880 ] && > $LOG              # 5000k, 5m

### Output via cron
if ! tty -s
then exec 1>> $LOG
     exec 2>> $LOG
fi

log() {
# screen: add to log explicitly
#   cron: already sending to log
    if tty -s
    then echo "$( date '+%Y-%m-%d %X'): $1" >> $LOG
    else echo "$( date '+%Y-%m-%d %X'): $1"
    fi
}

email() {
    subject="$(hostname) - Clean FRA"
    mail -s "$subject - $1" $MAIL_TO <<MAIL
From: no-reply@oracle
To: $MAIL_TO
Subject: $subject - $1

Log: $LOG

$( cat -n $LOG | tail -15 )

MAIL
}

log "BEGIN"
if rman <<RMAN
connect target /

    DELETE NOPROMPT ARCHIVELOG ALL COMPLETED BEFORE 'SYSDATE-7';

RMAN
then
    log "END"
    email "Success"
    exit 0;
else
    log "END"
    email "Error"
    exit 0;
fi


