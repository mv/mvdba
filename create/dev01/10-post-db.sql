connect "SYS"/"&&sysPassword" as SYSDBA

set echo on
spool 10-post-db.log

-- select group# from v$log where group# =3;
-- select group# from v$log where group# =4;
-- 
-- ALTER DATABASE
--     ADD LOGFILE THREAD 2
--     GROUP 3 SIZE 50M,
--     GROUP 4 SIZE 50M
--     ;
-- 
-- ALTER DATABASE
--     ENABLE PUBLIC THREAD 2;
-- 
-- connect "SYS"/"&&sysPassword" as SYSDBA

set echo on
create spfile='/u01/app/oracle/admin/dev01/pfile/spfiledev01.ora'
  FROM  pfile='/u01/app/oracle/admin/dev01/pfile/initdev01.ora';

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



