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

sleep 6


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
echo "  PFILE='$ORACLE_HOME/dbs/init`echo $ORACLE_SID`.ora';                    " >>$DUPLICATEFILE
echo "  RELEASE CHANNEL c1;                                                     " >>$DUPLICATEFILE
echo "  RELEASE CHANNEL c2;                                                     " >>$DUPLICATEFILE
echo " }                                                                        " >>$DUPLICATEFILE

rman target sys/$SYSPASS@$SOURCEDB catalog rman/$RMANPASS trace $RMANLOGFILE @$DUPLICATEFILE

# Fim do Duplicate...
echo ""
echo ""
echo "  ---------------------------------"
echo "    Verifique Status do BANCO !!!  "
echo "  ---------------------------------"
echo ""
echo ""


