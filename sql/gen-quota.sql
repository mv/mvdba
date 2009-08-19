
select 'alter user '||rpad(username,'31',' ') ||' quota unlimited on '||default_tablespace||';'
  from dba_users
 where default_tablespace not in   ('SYSTEM','USERS','SYSAUX','TEMP')
   and default_tablespace not like 'OEM%'
 order by username
/

