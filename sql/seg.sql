--
--
-- seg.sql
--    user segments
--
-- Usage:
--     SQL> @seg [OWNER]
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-09
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

COLUMN segment_name     FORMAT A30
COLUMN tablespace_name  FORMAT A20
COLUMN partition_name   FORMAT A20

SELECT owner
     , segment_name
     , segment_type
     , tablespace_name
     , TO_CHAR(bytes/1024/1024, '999g990d00') mega
     , partition_name
     , extents
     , initial_extent   ini_ext
     , next_extent      nxt_ext
     , min_extents      min_ext
     , max_extents      max_ext
     , pct_increase     pct_inc
  FROM dba_segments
 WHERE 1=1
   AND owner LIKE UPPER('%&&1%')
 ORDER BY owner
        , segment_type
        , segment_name
/

SET FEEDBACK ON
SET VERIFY   ON

undef 1

