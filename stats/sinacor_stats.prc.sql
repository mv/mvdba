CREATE OR REPLACE PROCEDURE sinacor_stats IS
    --
    -- Marcus Vinicius Ferreira       ferreira.mv[ at ]gmail.com
    -- Oracle do Brasil     Jan/2008
    -- pre-req:
    --     GRANT ANALYZE ANY TO <<procedure_owner>>
    --
    TYPE vc_list IS TABLE OF VARCHAR2(30);
    owners vc_list;
    --
BEGIN
    --
    owners := vc_list( 'HOMEB','SINACORR' );
    owners := vc_list( 'SANA','SINAWIN','CORRWIN' );
    --
    FOR i IN owners.FIRST .. owners.LAST
    LOOP
        DBMS_STATS.GATHER_SCHEMA_STATS
            ( ownname          => owners(i)
            , estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE
            , degree           => DBMS_STATS.AUTO_DEGREE
            );
    END LOOP;
    --
END;
/

show err

-- @F:\migracao_sinacor\job\sinacor_stats.prc.sql

