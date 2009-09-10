--
--
-- obj-drop.sql
--    user objects
--
-- Usage:
--     SQL> @obj [owner|%] [valid|invalid]
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--


SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY   OFF

SELECT 'drop '||RPAD(object_type, 15, ' ')
    || RPAD(owner ||'.'|| object_name, 62, ' ' )
    || DECODE( object_type, 'TABLE', ' cascade constraints ')
    || ' -- '||status
    || ' ;'
  FROM dba_objects
 WHERE 1=1
   AND owner    LIKE UPPER('%&&1%')
   AND status = NVL( UPPER('&&2'), status)
   AND object_type NOT LIKE '%LOB%'
   AND object_type NOT IN ('PACKAGE BODY','INDEX')
 ORDER BY owner
        , object_type
        , object_name
/

SET FEEDBACK ON
SET VERIFY   ON
SET PAGESIZE 200

undef 1
undef 2

