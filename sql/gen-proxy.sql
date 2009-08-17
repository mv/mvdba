--
-- gen-proxy.sql
--     proxy: grant connect through TO DBA_USER
--
-- Marcus Vinicius Ferreira                     ferreira.mv[ at ]gmail.com
-- 2009/Jun
--

SET TRIMSPOOL ON
SET TRIMOUT   ON

select 'alter user '||RPAD(username,31,' ')||' grant connect through MVDBA;'
  from dba_users
 where username NOT IN ('DBSNMP'
                       ,'XDB'
                       ,'ANONYMOUS'
                       ,'MVDBA'
                       )
   and username NOT LIKE '%SYS%'
 order by 1

spool proxy_mvdba.sql
/
spool off

