REM
REM chkspc.sql
REM Check Space per TABLESPACEs
REM
REM Marcus Vinicius Ferreira 20/Jun/2000
REM
COLUMN tablespace_name FORMAT a15
COLUMN file_name       FORMAT a40

SELECT ddf.tablespace_name
     , ddf.file_name
     , vdf.status
     , TO_CHAR((ddf.bytes / 1024 / 1024)                   ,  '9g990d000')  "Size (M)"
     , TO_CHAR(((ddf.bytes - free.bytes) / 1024 / 1024)    ,  '9g990d000')  "Used (M)"
     , TO_CHAR( (ddf.bytes - free.bytes) / free.bytes * 100,  '99990d00' )  "% Used"
     , SUBSTR('##################!!', 1, (ddf.bytes - free.bytes) / ddf.bytes * 20)  "SpaceUsed "
     , ddf.file_id
     , ddf.autoextensible||'    '  "AutoExt"
     , ddf.increment_by
     , ddf.maxblocks
  FROM sys.dba_data_files           ddf
     , v$datafile                   vdf
     , (SELECT file_id
             , SUM(bytes) bytes
          FROM sys.dba_free_space
         GROUP BY file_id)          free
 WHERE (free.file_id (+)= ddf.file_id)
   AND (ddf.file_name   = vdf.name)
 ORDER BY TO_CHAR( (ddf.bytes - free.bytes) / ddf.bytes * 100,  '99990d00' ) DESC
        , ddf.tablespace_name ASC
        , ddf.file_name       ASC
/
