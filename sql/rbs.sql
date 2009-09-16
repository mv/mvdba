set linesize 200
set pagesize 200

spool rbs_df.txt

prompt "Rollbacks "
SELECT rbs.segment_name
     , rbs.owner
     , rbs.tablespace_name
     , rbs.initial_extent/1024 "initial kb"
     , rbs.next_extent         "next kb"
     , rbs.min_extents
     , rbs.max_extents
     , sgs.extents
     , rbs.status
 FROM dba_rollback_segs rbs
    , dba_segments      sgs
WHERE rbs.segment_name = sgs.segment_name
/

prompt "Data Files"
SELECT ddf.file_name
     , ddf.tablespace_name
     , ddf.bytes/1024/1024    "size mb"
     , ddf.status
     , ddf.autoextensible
 FROM dba_data_files ddf
/

column mb format 999g999g999d00
prompt "Espaço livre em tbspc"
SELECT tablespace_name
     , SUM(bytes)/1024/1024 mb
  FROM dba_free_space
 GROUP BY tablespace_name
/

spool off
