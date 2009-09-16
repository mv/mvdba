
set serveroutput on size 1000000

DECLARE
    CURSOR c1 IS
    select owner, object_name as name, object_type, status
    from dba_objects
    where status <> 'VALID'
      and object_type like 'MATER%'
      and owner = 'APPS'
    --  and rownum<=3
    order by object_name
    ;
    PROCEDURE p (msg IN VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(msg);
        -- EXECUTE IMMEDIATE ( REPLACE(msg, ';', NULL) );
    END;
BEGIN
    DBMS_OUTPUT.ENABLE;
    FOR r1 IN c1
    LOOP
        p( 'create table           '||RPAD(r1.name||'_ttb',31,' ')||' AS SELECT * FROM '||r1.name||' WHERE 1=2 ;' );
        p( 'drop materialized view '||RPAD(r1.name        ,31,' ')||' ;' );
        p( 'rename                 '||RPAD(r1.name||'_ttb',31,' ')||' to               '||r1.name||'           ;' );
    END LOOP;

END;
.

spool /tmp/1.sql
/
spool off
set echo on
@/tmp/1.sql

-- @F:\home\marcus\work\branch\marcus.ferreira\atg\mview_invalid_apps\1.sql

.

