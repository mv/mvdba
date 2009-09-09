--
--
-- rbin-purge.sql
--    purge user recyble bin
--
-- Usage:
--     SQL> @rbin-purge [OWNER]
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

SELECT 'purge '||RPAD(type,20,' ')||' '
    || owner ||'.'|| CHR(34)||object_name||CHR(34)
    || '  ;'
  FROM dba_recyclebin
 WHERE 1=1
   AND owner LIKE UPPER('%&&1%')
   AND type NOT LIKE 'LOB%'
   AND type NOT LIKE 'INDEX'
 ORDER BY owner
        , object_name
        , type
/

SET FEEDBACK ON
SET VERIFY   ON

undef 1

