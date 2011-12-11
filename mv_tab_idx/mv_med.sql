-- $Id: mv_med.sql 6 2006-09-10 15:35:16Z marcus $
--

set pagesize 0
set linesize 200
set trimspool on
set feedback off
set timing off
set verify off

spool /tmp/mv_med_1.sql

SELECT 'alter table '||RPAD(table_name,31,' ')||' move tablespace &&1 '
    || ' storage (initial 4096k next 4096k minextents 1 maxextents 4096) '
    || ' ; '
 FROM user_tables
ORDER BY table_name
/

spool off

set echo on
set timing on
set feedback on

-- @@/tmp/mv_med_1.sql

-- @C:\work\dba\move\mv_med.sql
