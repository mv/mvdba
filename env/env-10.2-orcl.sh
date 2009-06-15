#!/usr/bin/env bash
#
# Oracle global environment
#
#     to be "sourced" by cron jobs
#
# Marcus Vinicius Ferreira           ferreira.mv[ at ]gmail.com
# Jun/2009
#

export  ORACLE_SID=orcl
export ORACLE_HOME=/u01/app/oracle/product/10.2.0.4/db_1

export NLS_LANG='AMERICAN_AMERICA.WE8ISO8859P1'

export              PATH=${ORACLE_HOME}/bin:$PATH
export   LD_LIBRARY_PATH=${ORACLE_HOME}/lib:$LD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=${ORACLE_HOME}/lib:$DYLD_LIBRARY_PATH

export MAIL_TO="marcus.ferreira@abril.com.br"

