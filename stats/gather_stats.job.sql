

set serveroutput on size 1000000

DECLARE
    job_id BINARY_INTEGER;
BEGIN
    DBMS_JOB.SUBMIT( job       => job_id
                   , what      => 'monitor.sinacor_stats;'
                   , next_date => TO_DATE( '2008-01-29 01:30','YYYY-MM-DD HH24:MI')
                   , interval  => 'SYSDATE + 1'
                   );
    --
    COMMIT; -- NT/8i bug (?)
    --
    DBMS_OUPUT.PUT_LINE('Created Job: '||job_id);
    --
END;
/


