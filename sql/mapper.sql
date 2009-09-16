rem
rem mapper.sql
rem    mapa da utilizacao de area pelos objetos e de area livre (tablespace)
rem

DEFINE tablespace = &tablespace
SET VERIFY OFF
SET HEADING ON

COLUMN "Object" FORMAT A25
COLUMN "Type"  FORMAT A15

SELECT '===> Free Space' "Object"
     , NULL              "Type"
     , file_id
     , block_id
     , blocks
     , (bytes) / 1024 kbytes
  FROM sys.dba_free_space
 WHERE tablespace_name = UPPER('&&tablespace')
 UNION
SELECT SUBSTR(segment_name,1,32) "Object"
     , segment_type              "Type"
     , file_id
     , block_id
     , blocks
     , (bytes) / 1024 kbytes
  FROM sys.dba_extents
 WHERE tablespace_name = UPPER('&&tablespace')
 ORDER BY file_id,block_id;

SET VERIFY ON
UNDEFINE TABLESPACE
