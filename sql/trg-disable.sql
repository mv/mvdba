--
--
-- trg-disable.sql
--    user triggers - disable
--
-- Usage:
--     SQL> @trg-disable
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2010-03
--


SET PAGESIZE 200
SET FEEDBACK OFF
SET VERIFY   OFF

SET HEADING OFF
SET TIMING  OFF

SELECT 'alter trigger '       || RPAD( trigger_name, 50, ' ' )
    || ' enable '
    || ';' cmd
  FROM user_triggers
 WHERE 1=1
   AND status <> 'DISABLED'
 ORDER BY trigger_name
/

SET HEADING ON
SET TIMING  ON

SET FEEDBACK ON
SET VERIFY   ON


