
clear screen

set trimspool on
set pagesize 200
set linesize 1000
set feedback on
set echo on

column member       format a60
column name         format a90
column dest_name    format a60
column dependency   format a20
column destination  format a30
column remote_template  format a20
column input_bytes_display  format a20
column output_bytes_display  format a20

alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';

spool redolog.txt

select * from v$log     order by 1;
select * from v$logfile order by 1;
-- select * from v$loghist;
select * from v$log_history;

select * from v$archive;
select * from v$archived_log;
select * from v$archive_dest;
select * from v$archive_dest_status;
select * from v$archive_gap;
select * from v$archive_processes;

select * from v$backup_redolog;
select * from v$backup_archivelog_details ;
select * from v$backup_archivelog_summary ;

select * from v$recovery_log;

select * from dba_log_groups;

set linesize 100

spool off
