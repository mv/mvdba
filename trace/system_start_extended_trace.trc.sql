CREATE OR REPLACE TRIGGER system.start_extended_trace
                    AFTER LOGON
                       ON system.SCHEMA
BEGIN
    -- ref: http://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:6020271977738#15950172249229
    IF USER = 'SYSTEM'
    THEN
        EXECUTE IMMEDIATE 'alter session set timed_statistics = TRUE' ;
        EXECUTE IMMEDIATE 'alter session set max_dump_file_size = unlimited';
        EXECUTE IMMEDIATE 'alter session set tracefile_identifier=homeb'  ;
        EXECUTE IMMEDIATE 'alter session set events ''10046 trace name context forever, level 12''';
    END IF;
END;
/

ALTER TRIGGER System.Start_Extended_Trace DISABLE;

