. /home/orahom/.bash_profile

SOURCEDB="EBSDB"
DUPLICATEFILE=$ORACLE_HOME/admin/udump/duplicate_`$ORACLE_SID`_`date '+%G_%m_%d'`.rman
RMANLOGFILE=$ORACLE_HOME/admin/udump/log_duplicate_`$ORACLE_SID`_`date '+%G_%m_%d'`.log
RMANPASS="dba1cf42@rman"
SYSPASS="alsmnydxs"

clear
echo ""
echo ""
echo ""
echo ""
echo "          ----------------------------------------------"
echo "                 O banco \"$ORACLE_SID\" sera dropado!!!"
echo "          ----------------------------------------------"
echo ""
echo ""
echo "  -------------------------------------------------------------"
echo "      Caso esteja arrependido da merda que pode vir a fazer,   "
echo "             voce tem 1 minuto para matar o PID \"`ps -fe    | \
                                                grep -i autoclonedb | \
                                                tr -s " "           | \
                                                cut -d " " -f2      | \
                                                grep -v grep        | \
                                                head -n1`\"".
echo "  -------------------------------------------------------------"
echo ""
echo ""
echo ""

sleep 60


# Iniciando Drop Database...
echo ""
echo "# Iniciando Drop Database... "
sqlplus /nolog  <<EOF
conn / as sysdba ;
shutdown abort ;
conn / as sysdba ;
startup restrict mount ;
drop database ;
conn / as sysdba ;
shutdown abort ;
conn / as sysdba ;
startup pfile=?/dbs/initHOM.ora nomount ;
exit ;
EOF

# Prerando arquivo para Duplicate RMAN...
echo ""
echo "# Prerando arquivo para Duplicate RMAN... "
echo ""
echo " connect auxiliary /                                                      "  >$DUPLICATEFILE
echo "                                                                          " >>$DUPLICATEFILE
echo " RUN {                                                                    " >>$DUPLICATEFILE
echo "  ALLOCATE AUXILIARY CHANNEL c1 DEVICE TYPE DISK;                         " >>$DUPLICATEFILE
echo "  ALLOCATE AUXILIARY CHANNEL c2 DEVICE TYPE DISK;                         " >>$DUPLICATEFILE
echo "  DUPLICATE TARGET DATABASE TO '$ORACLE_SID'                              " >>$DUPLICATEFILE
echo "  PFILE='$ORACLE_HOME/dbs/init`echo $ORACLE_SID`.ora'; 			" >>$DUPLICATEFILE
echo "  RELEASE CHANNEL c1;                                                     " >>$DUPLICATEFILE
echo "  RELEASE CHANNEL c2;                                                     " >>$DUPLICATEFILE
echo " }                                                                        " >>$DUPLICATEFILE

rman target sys/$SYSPASS@$SOURCEDB catalog rman/$RMANPASS trace $RMANLOGFILE @$DUPLICATEFILE


# Alterando senha do system...
echo ""
echo "# Alterando senha do system... "
sqlplus /nolog  <<EOF
conn / as sysdba ;
alter user system identified by manager ;
exit ;
EOF


# Desligando archivelog e flashback...
echo ""
echo "# Desligando archivelog e flashback... "
sqlplus /nolog  <<EOF
conn / as sysdba ;
shutdown immediate ;
conn / as sysdba ;
startup nomount ;
alter database mount exclusive ;
alter database flashback off ;
alter database noarchivelog ;
alter database open ;
exit ;
EOF


# Criando area temporaria...
echo ""
echo "# Criando area temporaria... "
sqlplus /nolog  <<EOF
conn / as sysdba ;
ALTER TABLESPACE TEMP ADD TEMPFILE '+DATA01' SIZE 2000M REUSE AUTOEXTEND OFF;
exit ;
EOF


# Recriando db-links...
echo ""
echo "# Recriando db-links... "
sqlplus /nolog  <<EOF
conn / as sysdba ;
drop public database link MDBDB_SENIORMDB.MDB.COM.BR;
drop public database link SATDB_GEO.MDB.COM.BR;
drop public database link SATDB_MERCADOR.MDB.COM.BR;
drop public database link MDBDB_SCA.MDB.COM.BR;
drop public database link MDBDB_LOGIX.MDB.COM.BR;
drop public database link SATDB_SENIORMDB.MDB.COM.BR;
drop public database link SATDB_GESPLAN.MDB.COM.BR;
create public database link MDBDB_SENIORMDB.MDB.COM.BR connect to SENIORMDB identified by SENIORMDB using 'SATDB_SINGLE';
create public database link SATDB_GEO.MDB.COM.BR connect to GEO identified by GEO using 'SATDB_SINGLE';
create public database link SATDB_MERCADOR.MDB.COM.BR connect to MERCADOR identified by MERCADOR using 'SATDB_SINGLE';
create public database link MDBDB_SCA.MDB.COM.BR connect to SCA identified by SCA using 'SATDB_SINGLE';
create public database link MDBDB_LOGIX.MDB.COM.BR connect to LOGIX identified by LOGIX using 'SATDB_SINGLE';
create public database link SATDB_SENIORMDB.MDB.COM.BR connect to SENIORMDB identified by SENIORMDB using 'SATDB_SINGLE';
create public database link SATDB_GESPLAN.MDB.COM.BR connect to GESPLAN identified by GESPLAN using 'SATDB_SINGLE';
exit ;
EOF


# Update para invalidar emails...
echo ""
echo "# Update para invalidar emails... "
sqlplus apps/seubps0105  <<EOF
update hr.per_all_people_f set attribute30=email_address, email_address='XPTO'||email_address where  email_address is not null and upper(email_address) not like 'UNI%' ;
update applsys.fnd_user set email_address= 'XPTO'||email_address where email_address is not null and upper(email_address) not like 'UNI%';
commit ;
exit ;
EOF


# Fim do Duplicate...
echo ""
echo ""
echo "  ---------------------------------"
echo "    Verifique Status do BANCO !!!  "
echo "  ---------------------------------"
echo ""
echo ""


