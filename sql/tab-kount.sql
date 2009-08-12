--
--
-- tab-kount.sql
--    count from user tables
--
-- Usage:
--     SQL> @tab-kount
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--


SET SERVEROUTPUT ON SIZE 1000000

SET FEEDBACK OFF
SET TIMING   OFF

SELECT user, TO_CHAR( SYSDATE, 'yyyy-mm-dd hh24:mi:ss') as "Date"
  FROM DUAL;

DECLARE
    --
    v NUMBER := 1;
    --
    PROCEDURE p ( msg IN VARCHAR2 ) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE( msg );
    END p;
    --
    -----
    --
BEGIN
    p( CHR(10) );
    --
    FOR r IN ( SELECT table_name FROM user_tables ORDER BY table_name )
    LOOP
        EXECUTE IMMEDIATE 'select count(1) from '||r.table_name INTO v;
        p( RPAD(r.table_name, 31, ' ') || TO_CHAR(v, '999g999g999g999') );
    END LOOP;
    --
    p( CHR(10) );
    --
END;
/

SET FEEDBACK ON
SET TIMING   ON

