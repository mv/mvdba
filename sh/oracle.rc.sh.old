# $Id: oracle.rc.sh 6 2006-09-10 15:35:16Z marcus $
#
# /etc/oratab
LSC01:/app/oracle/oracle/product/10.2.0/db_2:Y
+ASM1:/home/oracle/oracle/product/10.2.0/db_2:Y
RAC1:/home/oracle/oracle/product/10.2.0/db_2:Y
RAC2:/home/oracle/oracle/product/10.2.0/db_2:Y
crs:/app/oracle/product/10.2.0/crs:N

eval $(awk -F: '/^[+a-zA-Z]/{l=tolower($1); sub("^+","",l); print "alias "l"=\047x="$2";PATH=${PATH//$ORACLE_HOME/$x}; ORACLE_HOME=$x; ORACLE_SID="$1"; echo ORACLE_SID="$1"; \047; "}' /etc/oratab 2>/dev/null)

alias asm1='x=/home/oracle/oracle/product/10.2.0/db_2; PATH=${PATH//$ORACLE_HOME/$x}; ORACLE_HOME=$x; ORACLE_SID=+ASM1; echo ORACLE_SID=+ASM1;'
alias crs='x=/app/oracle/product/10.2.0/crs; PATH=${PATH//$ORACLE_HOME/$x};ORACLE_HOME=$x; ORACLE_SID=crs; echo ORACLE_SID=crs;'
alias lsc01='x=/app/oracle/oracle/product/10.2.0/db_2; PATH=${PATH//$ORACLE_HOME/$x};ORACLE_HOME=$x; ORACLE_SID=LSC01; echo ORACLE_SID=LSC01;'
alias rac1='x=/home/oracle/oracle/product/10.2.0/db_2; PATH=${PATH//$ORACLE_HOME/$x}; ORACLE_HOME=$x; ORACLE_SID=RAC1; echo ORACLE_SID=RAC1;'
alias rac2='x=/home/oracle/oracle/product/10.2.0/db_2; PATH=${PATH//$ORACLE_HOME/$x}; ORACLE_HOME=$x; ORACLE_SID=RAC2;echo ORACLE_SID=RAC2;'



[ -z "$ORACLE_SID" ] && export ORACLE_SID=LSC01
export ORACLE_HOME=$(sed -n "s/:.$//;s/^$ORACLE_SID://p" /etc/oratab)
PATH=$ORACLE_HOME/bin
PATH=$PATH:$ORACLE_HOME/opmn/bin
PATH=$PATH:$ORACLE_HOME/dcm/bin
PATH=$PATH:$HOME/bin
PATH=$PATH:/usr/local/bin
PATH=$PATH:/usr/bin
PATH=$PATH:/usr/X11R6/bin
PATH=$PATH:/bin
PATH=$PATH:/usr/sbin
PATH=$PATH:/opt/gnome/bin
PATH=$PATH:/opt/kde3/bin
PATH=$PATH:.
export PATH




alias abort='echo shutdown abort|sqlplus -L -s / as sysdba'
alias alert='vi $ORACLE_HOME/admin/$ORACLE_SID/bdump/alert_$ORACLE_SID.log'
alias nomount='echo startup nomount quiet|sqlplus -L -s / as sysdba'
alias ora='cd $ORACLE_HOME'
alias pmon='ps -ef | grep [p]mon'
alias startup='echo startup quiet|sqlplus -L -s / as sysdba'
alias sysdba='sqlplus -L / as sysdba'
alias tns='cd $ORACLE_HOME/network/admin'


alias bdump='cd $ORACLE_BASE/admin/$ORACLE_SID/bdump/'
alias cdump='cd $ORACLE_BASE/admin/$ORACLE_SID/cdump/'
alias dbs='cd $ORACLE_HOME/dbs'
alias disp='export DISPLAY=$(ip):0.0'
alias pmon='ps -ef|grep pmon|grep -v grep|cut -c58-'
alias sid='echo $ORACLE_SID'
alias talert='tail -f $ORACLE_BASE/admin/$ORACLE_SID/bdump/alert_$ORACLE_SID.log'
alias tns='cd $ORACLE_HOME/network/admin'
alias udump='cd $ORACLE_BASE/admin/$ORACLE_SID/udump/'
alias valert='vi $ORACLE_BASE/admin/$ORACLE_SID/bdump/alert_$ORACLE_SID.log'



alias oracle='su - oracle -c "DISPLAY=$DISPLAY ORACLE_HOME=$ORACLE_HOME ORACLE_SID=$ORACLE_SID PATH=$PATH bash --rcfile ~lsc/.bashrc"'



p() {
    sqlplus -L -s "/ as sysdba" <<EOF | sed -n 's/@ //p'
    set echo off lin 9999 trimsp on feedb off head off pages 0 tab off
    col name for a25
    select '@',name, value from v\$parameter2 where upper(name) like upper('%$1%');
EOF
}
P() {
    sqlplus -L -s "/ as sysdba" <<EOF | sed -n 's/@ //p'
    set echo off lin 9999 trimsp on feedb off head off pages 0 tab off
    col name for a25
    select '@',ksppinm name,ksppstvl value FROM x\$ksppi join x\$ksppcv using (inst_id,indx) where upper(ksppinm) like upper('%$1%');
EOF
}

