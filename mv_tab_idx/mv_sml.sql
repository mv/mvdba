-- $Id: mv_sml.sql 6 2006-09-10 15:35:16Z marcus $
--

set pagesize 0
set linesize 200
set trimspool on
set feedback off
set timing off
set verify off

spool /tmp/mv_sml_1.sql

SELECT 'alter table '||RPAD(table_name,31,' ')||' move tablespace &&1 '
    || ' storage (initial 128k next 128k minextents 1 maxextents 4096) '
    || ' ; '
 FROM user_tables
-- WHERE tablespace_name = 'FED01D'
ORDER BY table_name
/

spool off

set echo on
set timing on
set feedback on

-- @@/tmp/mv_sml_1.sql

-- @C:\work\dba\move\mv_sml.sql
