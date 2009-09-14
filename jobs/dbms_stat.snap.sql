DECLARE
    j BINARY_INTEGER;
BEGIN
    DBMS_JOB.SUBMIT
        ( what      => 'dbms_stat.snap'
        , next_date => TRUNC(SYSDATE)+2
        , interval  => 'TRUNC(SYSDATE)+2+1/24'
        , job       => j
        );
END;
/

