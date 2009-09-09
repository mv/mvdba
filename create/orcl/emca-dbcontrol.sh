
/u01/app/oracle/product/10.2.0/db_1/bin/emca
    -config         dbcontrol db
    -silent
    -cluster
    -CLUSTER_NAME   crs
    -HOST           server3
    -NODE_LIST      server3,server4
    -SID_LIST       RAC1,RAC2
    -DB_UNIQUE_NAME RAC
    -SID            RAC
    -SYS_PWD        &&sysPassword
    -ORACLE_HOME    /u01/app/oracle/product/10.2.0/db_1
    -LISTENER       LISTENER
    -PORT           1521
    -SERVICE_NAME   RAC
    -LISTENER OH    /u01/app/oracle/product/10.2.0/db_1
    -ASM_SID        +ASM1
    -ASM_USER_ROLE  SYSDBA
    -ASM_USER_NAME  SYS
    -ASM_USER_PWD   &&asmSysPassword
    -ASM_PORT       1521
    -ASM OH         /u01/app/oracle/product/10.2.0/asm_1
    -EM_HOME        /u01/app/oracle/product/10.2.0/em_1
    -SYSMAN_PWD     &&sysmanPassword
    -DBSNMP_PWD     &&dbsnmpPassword
    -LOG_FILE       /u01/app/oracle/admin/RAC/scripts/emConfig.log
    ;


