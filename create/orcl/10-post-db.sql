connect "SYS"/"&&sysPassword" as SYSDBA

set echo on
spool 10-post-db.sql

select group# from v$log where group# =3;
select group# from v$log where group# =4;

ALTER DATABASE
    ADD LOGFILE THREAD 2
    GROUP 3 SIZE 50M,
    GROUP 4 SIZE 50M
    ;

ALTER DATABASE
    ENABLE PUBLIC THREAD 2;

spool off

connect "SYS"/"&&sysPassword" as SYSDBA

set echo on
create spfile='+DISKGROUP1/${dbname}/spfile${dbsid}.ora'
  FROM  pfile='/u01/app/oracle/admin/RAC/scripts/init.ora';

shutdown immediate;


connect "SYS"/"&&sysPassword" as SYSDBA

startup ;

alter user SYSMAN identified by "&&sysmanPassword" account unlock;
alter user DBSNMP identified by "&&dbsnmpPassword" account unlock;

alter user SCOTT account unlock;
revoke unlimited tablespace from SCOTT;

revoke create view   from connect;
revoke create dblink from connect
grant  create view   to   resource;
grant  create dblink to   resource;

select 'utl_recomp_begin: ' || to_char(sysdate, 'HH:MI:SS') from dual;
execute utl_recomp.recomp_serial();
select 'utl_recomp_end: ' || to_char(sysdate, 'HH:MI:SS') from dual;


spool off

exit;


