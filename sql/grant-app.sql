--
--
-- grant-app.sql - ABD
--    grant privileges to app roles:
--        RL_app_READ
--        RL_app_EXEC
--        RL_app_FULL
--
-- Usage:
--    connect OWNER/pass
--    @grant-app app_name
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-11
--

SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET TIMING OFF
SET PAGESIZE 0
SET LINESIZE 200

DEFINE _app=&1

spool /tmp/g.sql

SELECT 'grant select  on '||RPAD(object_name,31,' ')                   ||' to RL_&&_app._READ -- '||object_type||';'
  FROM user_objects
 WHERE object_type IN ('TABLE','VIEW','SEQUENCE')
 ORDER BY object_type,1
/

SELECT 'grant execute on '||RPAD(object_name,31,' ')                   ||' to RL_&&_app._EXEC -- '||object_type||';'
  FROM user_objects
 WHERE object_type IN ('PROCEDURE','FUNCTION','PACKAGE','TYPE')
 ORDER BY object_type,1
/

SELECT 'grant select,insert,update,delete on '||RPAD(table_name,31,' ')||' to RL_&&_app._FULL -- TABLE;'
  FROM user_tables
 ORDER BY 1
/

spool off

SET PAGESIZE 200
SET FEEDBACK ON
SET ECHO ON
@ /tmp/g.sql

