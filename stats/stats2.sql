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

