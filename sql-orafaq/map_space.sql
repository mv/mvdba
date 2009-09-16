REM  Map of free and used space

rem
rem   file: mapper.sql
rem   Parameters: the tablespace name being mapped
rem
rem   Sample invocation:
rem   @mapper DEMODATA
rem
rem   This script generates a mapping of the space usage
rem   (free space vs used) in a tablespace. It graphically
rem   shows segment and free space fragmentation.
rem
set pagesize 60 linesize 132 verify off
column file_id heading "File|Id"
select
      'free space' Owner,    /*"owner" of free space*/
      '   '  Object,         /*blank object name*/
      File_ID,               /*file ID for the extent header*/
      Block_ID,              /*block ID for the extent header*/
      Blocks                 /*length of the extent, in blocks*/
 from DBA_FREE_SPACE
where Tablespace_Name = UPPER('&&1')
union
select
      SUBSTR(Owner,1,20),         /*owner name (first 20 chars)*/
      SUBSTR(Segment_Name,1,32),  /*segment name*/
      File_ID,                    /*file ID for extent header*/
      Block_ID,                   /*block ID for block header*/
      Blocks                    /*length of the extent in blocks*/
 from DBA_EXTENTS
where Tablespace_Name = UPPER('&&1')
order by 3,4

spool &&1._map.lst
/
spool off
undefine 1

