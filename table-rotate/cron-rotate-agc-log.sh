#!/bin/bash
#
# cron-rotate-agc-log
#     wrapper: rotate table agc_adm.log
#
#     must be executed on the first day of each month:
#         * * 1 * * /path/cron-rotate-agc-log -f > /dev/null
#
# Marcus Vinicius Ferreira                      ferreira.mv[ at ]gmail.com
# 2009/Set
#

[ -z "$1" ] && {
    echo
    echo "Usage: $0 -f"
    echo
    echo "    rotate table agc_adm.log"
    echo
    exit 1
}

. /u01/app/oracle/config/env-ora.sh

# Log
[ -z $LOG_DIR ] && LOG_DIR=/tmp
LOG=${LOG_DIR}/${0##*/}.log ; >$LOG

# Auto-rotate
size=$( /bin/ls -l $LOG | awk '{print $5}' ) # size bytes
[ $size -gt 5242880 ] && > $LOG              # 5000k, 5m

# Subs
prev_month() {
perl -e '
    # current day/month/year
    my ($dd, $mm, $yy) = (localtime)[3,4,5];

    # first day of current month/year to epoch
    use Time::Local; #sec, min, hr, mday,  mm,  yy);
    $time = timelocal(  0,   0,  0,    1, $mm, $yy);

    # previous day, i.e., previous month
    $time -= 60 * 60 * 24 * 1 ; # 24h = 1d

    # epoch to my date
    use Time::localtime;
    $tm = localtime($time);
    printf("%04d_%02d\n", $tm->year+1900, $tm->mon+1);
'
}

log() {
    echo "$( date '+%Y-%m-%d %X'): $1" | tee -a $LOG
}

email() {
    subject="$(hostname) - Rotate $OWNER $TABLE"
    mail -s "$subject - $1" $MAIL_TO <<MAIL
From: no-reply@oracle
To: $MAIL_TO
Subject: $subject - $1

$(tail -15 $LOG )

MAIL
}

exists_table() {
sqlplus -L -s $sysdba <<SQL
    WHENEVER SQLERROR EXIT FAILURE
    set time on
    set timing on

    DECLARE x NUMBER;
    BEGIN
        select 1
          into x
          from dba_objects
         where       owner=UPPER('$OWNER')
           and object_name=UPPER('$NEW_TABLE')
           ;
    EXCEPTION
        WHEN OTHERS THEN RAISE;
    END;
/
SQL
}

create_table() {
sqlplus -L -s $sysdba <<SQL
    WHENEVER SQLERROR EXIT FAILURE
    set time on
    set timing on

        create table ${OWNER}.$NEW_TABLE
        as select * from ${OWNER}.$TABLE
        where 1=1
        ;
SQL
}

copy_data() {
sqlplus -L -s $sysdba <<SQL
    WHENEVER SQLERROR EXIT FAILURE
    set time on
    set timing on

        insert into ${OWNER}.$NEW_TABLE
        select * from ${OWNER}.$TABLE
        where $DT_COLUMN <= TRUNC( SYSDATE,'MM' ) -- first hour current month
        ;
        commit;
SQL
}

purge_data() {
sqlplus -L -s $sysdba <<SQL
    WHENEVER SQLERROR EXIT FAILURE
    set time on
    set timing on

    BEGIN
        LOOP
            delete from ${OWNER}.$TABLE
            where $DT_COLUMN <= TRUNC( SYSDATE,'MM' ) -- first hour current month
               and rownum <= 100000
                 ;
            EXIT when SQL%NOTFOUND;
            ---
            commit ;
            ---
        END LOOP;
        commit ;
    END;
/
SQL
}

# Params
       DT=$( prev_month )
    OWNER="agc_adm"
    TABLE="log"
NEW_TABLE="agc_log_${DT}"
DT_COLUMN="dat_log"
    TBSPC="agc_log_data_rotate_01"

sysdba="/ as sysdba"
sysdba="system/sys"

### Main

log "BEGIN"

### 1/3
log "Creating table [$NEW_TABLE]"

if exists_table > /dev/null
then
    log "Table [$NEW_TABLE] already exists"
else
    if create_table
    then log "Table created."
    else
        log "Table error."
        email "Table Error"
        exit 2
    fi
fi

### 2/3
log "Copying data from [$TABLE] to [$NEW_TABLE]"

if copy_data
then
    log "Copy finished."
else
    log "Copy error."
    email "Copy Error"
    exit 3
fi

### 3/3
log "Purgind from [$TABLE]"
if purge_data
then
    log "Purge finished"
else
    log "Purge error."
    email "Purge Error"
    exit 4
fi

log "END"
email "Success"
exit 0;

