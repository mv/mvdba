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

SET FEEDBACK OFF
SET TIMING   OFF

SET SCAN ON
UNDEFINE usr db
COLUMN usr NEW_VALUE usr
COLUMN db  NEW_VALUE db
COLUMN dt  NEW_VALUE dt

SELECT LOWER(DECODE( INSTR(global_name, '.' )
                   , 0 , global_name
                   , SUBSTR(global_name, 1, INSTR(global_name, '.')-1))
        )                                       as db
     , LOWER(user)                              as usr
     , TO_CHAR( SYSDATE, 'yyyy-mm-dd-hh24miss') as dt
  FROM global_name -- V$DATABASE
/

spool /tmp/&&db._&&usr._&&dt..txt

UNDEFINE usr db

SET SERVEROUTPUT ON SIZE 1000000
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
    p( CHR(10)||'Table Count...'||CHR(10) );
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

spool off

SET FEEDBACK ON
SET TIMING   ON

