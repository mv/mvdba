--
-- Kill sessions by osuser
--
-- 2009/11

select 'alter system kill session '
       ||CHR(39)||sid||','||serial#||CHR(39)||';'
  from v$session
 where osuser=NVL('&1',osuser)

spool 1.sql
/
spool off

@1.sql

