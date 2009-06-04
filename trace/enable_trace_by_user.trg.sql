CREATE OR REPLACE TRIGGER enable_trace_by_user
                    AFTER LOGON
                       ON DATABASE
BEGIN
    -- Marcus Vinicius Ferreira - ORACLE ACS - ferreira.mv[ at ]gmail.com
    -- ref: http://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:330817260752
    --      http://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:6020271977738
    --
    -- pre-req:
    --     grant alter session to <<monitor_dba>>;
    --     grant alter system  to <<monitor_dba>>;
    --
    IF( USER='HOMEB' )
    OR( USER='CORRWIN')
    THEN
        EXECUTE IMMEDIATE 'alter session set timed_statistics=TRUE' ;
        EXECUTE IMMEDIATE 'alter session set max_dump_file_size=unlimited' ;
        EXECUTE IMMEDIATE 'alter session set tracefile_identifier='||LOWER(USER)  ;
        EXECUTE IMMEDIATE 'alter session set events '||CHR(39)||'10046 trace name context forever, level 12'||CHR(39) ;
    END IF;


END;
/

ALTER TRIGGER enable_trace_by_user DISABLE;



