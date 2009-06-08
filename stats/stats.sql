CREATE OR REPLACE PROCEDURE sinacor_stats IS
BEGIN
    DBMS_STATS.GATHER_SCHEMA_STATS( ownname          => 'SANA'
                                  , estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE
                                  , degree           => DBMS_STATS.AUTO_DEGREE
                                  );
    DBMS_STATS.GATHER_SCHEMA_STATS( ownname          => 'SINAWIN'
                                  , estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE
                                  , degree           => DBMS_STATS.AUTO_DEGREE
                                  );
    DBMS_STATS.GATHER_SCHEMA_STATS( ownname          => 'CORRWIN'
                                  , estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE
                                  , degree           => DBMS_STATS.AUTO_DEGREE
                                  );
END;
/

DECLARE
    job_id BINARY_INTEGER;
BEGIN
    DBMS_JOB.SUBMIT( job       => :job_id
                   , what      => 'monitor.sinacor_stats;'
                   , next_date => TO_DATE( '2008-01-29 01:30','YYYY-MM-DD HH24:MI')
                   , interval  => 'SYSDATE + 1'
                   );
    --
    COMMIT;
    --
END;
/

-- @F:\migracao_sinacor\stats.sql
