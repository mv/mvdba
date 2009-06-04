-- audsid: http://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:114412348062
-- trace :


CREATE OR REPLACE TRIGGER enable_trace_by_user
                    AFTER LOGON
                       ON DATABASE
DECLARE
    my_sid      NUMBER;
    my_serial#  NUMBER;
BEGIN
    -- Marcus Vinicius Ferreira - ORACLE ACS - ferreira.mv[ at ]gmail.com
    -- ref: http://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:330817260752
    --      http://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:6020271977738
    -- sid: http://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:114412348062
    --
    -- pre-req:
    --     grant alter session to <<monitor_dba>>;
    --     grant alter system  to <<monitor_dba>>;
    --     grant select on sys.v_$session to <<monitor_dba>>;
    --
    IF USER NOT IN ('CORRWIN','HOMEB')
    THEN
        RETURN;
    END IF;
    --
    SELECT sid,serial#
      INTO my_sid,my_serial#
      FROM v$session where sid = (SELECT sid FROM v$mystat WHERE ROWNUM=1);
    --
    EXECUTE IMMEDIATE 'alter session set timed_statistics=TRUE' ;
    EXECUTE IMMEDIATE 'alter session set max_dump_file_size=unlimited' ;
    EXECUTE IMMEDIATE 'alter session set tracefile_identifier='||LOWER(USER)  ;
    EXECUTE IMMEDIATE 'alter session set events '||CHR(39)||'10046 trace name context forever, level 12'||CHR(39) ;
    --


END;
/

ALTER TRIGGER enable_trace_by_user DISABLE;



