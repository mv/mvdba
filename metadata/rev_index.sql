
set pagesize 0
set longchunksize 32765
set long 1000
set linesize 1000
set trimspool on
set feedback off
set verify off

BEGIN
    DBMS_METADATA.SET_TRANSFORM_PARAM ( DBMS_METADATA.SESSION_TRANSFORM, 'PRETTY'               , TRUE  );
    DBMS_METADATA.SET_TRANSFORM_PARAM ( DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR'        , TRUE  );

    DBMS_METADATA.SET_TRANSFORM_PARAM ( DBMS_METADATA.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES'   , TRUE  );
    DBMS_METADATA.SET_TRANSFORM_PARAM ( DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE'              , FALSE );
    DBMS_METADATA.SET_TRANSFORM_PARAM ( DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE'           , TRUE  );
END;
/


spool &&1..idx.sql

SELECT 'connect &&1/&&1'||chr(10) from dual;
SELECT 'set echo on'||chr(10) from dual;
SELECT 'spool &&1..idx_spool.txt'||chr(10) from dual;

SELECT DBMS_METADATA.GET_DDL('INDEX', index_name, owner  )
  FROM dba_indexes      i
 WHERE i.index_name NOT IN (SELECT constraint_name
                              FROM dba_constraints c
                             WHERE c.owner           = i.owner
                               AND c.constraint_name = i.index_name)
   AND i.owner = NVL(UPPER('&&1'), i.owner)
/

SELECT 'spool off'||chr(10) from dual;

spool off

prompt
prompt perl -pi -e 's/ PCTFREE/ --PCTFREE/i' *.{tab,idx}.sql
prompt perl -pi -e 's/;/\n;/'                *.{tab,idx}.sql
prompt

--
-- @F:\work\bradesco.sinacor\tech\sql\rev_index.sql

exit
