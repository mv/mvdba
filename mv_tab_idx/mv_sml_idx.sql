-- $Id: mv_sml_idx.sql 6 2006-09-10 15:35:16Z marcus $
--

set pagesize 0
set linesize 200
set trimspool on
set feedback off
set timing off
set verify off

spool /tmp/mv_sml_idx_1.sql

SELECT 'alter index '||RPAD(index_name,31,' ')||' rebuild tablespace &&1 '
    || ' storage (initial 128k next 128k minextents 1 maxextents 4096) '
    || ' ; '
 FROM user_indexes
ORDER BY index_name
/

spool off

set echo on
set timing on
set feedback on

@@/tmp/mv_sml_idx_1.sql

-- @C:\usr\work\dba\move\mv_sml_idx.sql

