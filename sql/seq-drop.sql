--
--
-- seq-drop.sql
--    drop sequences
--
-- Usage:
--     SQL> @seq-drop
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2010-04
--


SET PAGESIZE 0
SET LINESIZE 1000
SET FEEDBACK OFF
SET VERIFY   OFF

SET HEADING OFF
SET TIMING  OFF

SELECT 'drop sequence '
    || RPAD(sequence_name, 31, ' ')
    || ' ;'
  FROM user_sequences
 WHERE 1=1
 ORDER BY sequence_name
/

SET HEADING ON
SET TIMING  ON

SET FEEDBACK ON
SET VERIFY   ON
SET PAGESIZE 200
SET LINESIZE 100


