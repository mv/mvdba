--
--
-- rbin.sql
--    user recyble bin
--
-- Usage:
--     SQL> @rbin [OWNER]
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-09
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

COLUMN original_name    FORMAT A30
COLUMN type             FORMAT A15
COLUMN ts_name          FORMAT A20
COLUMN partition_name   FORMAT A20

SELECT owner
     , object_name
     , original_name
     , operation
     , type
     , TO_CHAR(space/1024/1024, '999g990d00') mega
     , ts_name
--   , createtime
     , droptime
--   , dropscn
     , can_undrop       as "UNDO"
     , can_purge        as "PURGE"
--   , related
--   , base_object
--   , purge_object
     , partition_name
  FROM dba_recyclebin
 WHERE 1=1
   AND owner LIKE UPPER('%&&1%')
 ORDER BY owner
        , object_name
        , type
/

SET FEEDBACK ON
SET VERIFY   ON

undef 1

