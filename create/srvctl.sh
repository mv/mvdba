

# pre-req
#     execute rac1.sh on node 1
#     execute rac2.sh on node 2
#

# database
srvctl add database -d RAC -o $ORACLE_HOME -p +DISKGROUP1/RAC/spfileRAC.ora

# instance 1 and 2
srvctl add instance -d RAC -i RAC1 -n london1
srvctl add instance -d RAC -i RAC2 -n london2

# set CLUSTER DATABASE
sqlplus / as sysdba <<SQL
    startup mount
    alter system set cluster_database=true scope=spfile;
    shutdown immediate
SQL

# start cluster
srvctl start  database -d RAC
srvctl status database -d RAC


