--
--
-- seq.sql
--    user sequences
--
-- Usage:
--     SQL> @seq [OWNER]
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2010-04
--


SET PAGESIZE 0
SET LINESIZE 1000
SET FEEDBACK OFF
SET VERIFY   OFF

SELECT 'create sequence '
    || LPAD(sequence_name, 31, ' ')
    || ' increment by '||increment_by
--  || ' minvalue '||min_value
--  || ' maxvalue '||max_value
    || ' cache '||cache_size
    || DECODE(order_flag
             , 'Y',' order '
             , 'N',' noorder '
             , NULL)
    || DECODE(cycle_flag
             , 'Y',' cycle '
             , 'N',' nocycle '
             , NULL)
    || ' start with '||last_number
    || ' ; ' cmd
  FROM dba_sequences
 WHERE 1=1
   AND sequence_owner LIKE UPPER('%&&1%')
 ORDER BY sequence_name
/

SET FEEDBACK ON
SET VERIFY   ON
SET PAGESIZE 200
SET LINESIZE 100

undef 1

