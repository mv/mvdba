--
-- gen-proxy.sql
--     proxy: grant connect through TO DBA_USER
--
-- Usage:
--    sqlplus dba/pass@bd @ gen-proxy.sql newuser
--
-- Marcus Vinicius Ferreira                     ferreira.mv[ at ]gmail.com
-- 2009/Jun
--

SET PAGESIZE 0
SET LINESIZE 200
SET FEEDBACK OFF
SET VERIFY OFF
SET TIME    OFF
SET TIMING  OFF

SET SCAN ON
DEFINE _user=&&1

select 'alter user '||RPAD(username,31,' ')||' grant connect through &&_user;'
  from dba_users
 where username NOT IN ('DBSNMP'
                       ,'XDB'
                       ,'ANONYMOUS'
                       ,'MVDBA'
                       )
   and username NOT LIKE '%SYS%'
 order by 1

spool /tmp/proxy.sql
/
spool off

SET PAGESIZE  200

