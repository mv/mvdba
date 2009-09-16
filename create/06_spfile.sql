-- $Id: 06_spfile.sql 12704 2007-03-29 19:47:19Z marcus.ferreira $

CONNECT SYS/oracle AS SYSDBA


    CREATE SPFILE='?/dbs/spfiledb01.ora'
      FROM  PFILE='/u01/app/oracle/admin/db01/pfile/initdb01.ora'
      ;

    SHUTDOWN

CONNECT SYS/oracle AS SYSDBA

    STARTUP


