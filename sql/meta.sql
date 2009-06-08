--
--
-- Oracle 10g
--    Schema reverse engineering
--
-- Usage:
--    sqlplus CONNECT_USER/pass@bd @ metadata SCHEMA_NAME
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-06
--

SET LONG            1024000
SET LONGCHUNKSIZE   1024000
SET PAGESIZE        0
SET TRIMSPOOL       ON
SET TRIMOUT         ON
SET TIME            OFF
SET TIMING          OFF

SET FEEDBACK        OFF

set echo on

    -- pct{free,used}/{ini,max}trans/[no]compress/[no]logging
    exec  dbms_metadata.set_transform_param  (  dbms_metadata.session_transform,  'SEGMENT_ATTRIBUTES'  ,  true   );
    -- storage( initial/next/{min,max}extents/pctincrease/freelists/buffer pool/ )
    exec  dbms_metadata.set_transform_param  (  dbms_metadata.session_transform,  'STORAGE'             ,  false  );
    exec  dbms_metadata.set_transform_param  (  dbms_metadata.session_transform,  'TABLESPACE'          ,  true   );
    exec  dbms_metadata.set_transform_param  (  dbms_metadata.session_transform,  'REUSE'               ,  true   );
    
    exec  dbms_metadata.set_transform_param  (  dbms_metadata.session_transform,  'PRETTY'              ,  true   );
    exec  dbms_metadata.set_transform_param  (  dbms_metadata.session_transform,  'SQLTERMINATOR'       ,  true   );
    exec  dbms_metadata.set_transform_param  (  dbms_metadata.session_transform,  'CONSTRAINTS_AS_ALTER',  true   );
    exec  dbms_metadata.set_transform_param  (  dbms_metadata.session_transform,  'SPECIFICATION'       ,  true   );

set echo off
--  exec  dbms_metadata.set_remap_param  (  dbms_metadata.session_transform,  'REMAP_DATAFILE'   , 'ts_user_d' , 'user_data' );
--  exec  dbms_metadata.set_remap_param  (  dbms_metadata.session_transform,  'REMAP_TABLESPACE' , 'ts_user_d' , 'user_data' );
--  exec  dbms_metadata.set_remap_param  (  dbms_metadata.session_transform,  'REMAP_SCHEMA'     , 'SCOTT'     , 'LARRY'     );


spool /tmp/m1.sql

select dbms_metadata.get_ddl( object_type, object_name, owner )
  from dba_objects
 where 1=1
   and owner = UPPER('&&1')
   and object_type not in ( 'LOB'           , 'PACKAGE BODY'       , 'TYPE BODY'     -- ok...
                          , 'PROGRAM'       , 'JAVA CLASS'         , 'JAVA RESOURCE' -- #comofaz ?
                          , 'QUEUE'         , 'EVALUATION CONTEXT' , 'RULE SET'      -- #comofaz ?
                          , 'DATABASE LINK' , 'MATERIALIZED VIEW'  , 'UNDEFINED'     -- #comofaz ?
                          )
--   and object_name not like 'SYS_IOT_OVER%'
--   and object_name not in ('MGMT_DELTA_SUMMARY_ERRORS', 'PARAM_VALUES_TAB')
 order by object_type, object_name
/

select dbms_metadata.get_dependent_ddl( 'OBJECT_GRANT', table_name , owner ) -- AUDIT?
  from dba_tab_privs
 where 1=1
   and owner = UPPER('&&1')
 order by grantee, table_name, privilege
/

select dbms_metadata.get_granted_ddl( 'SYSTEM_GRANT', UPPER('&&1') ) from dual ;
select dbms_metadata.get_granted_ddl( 'ROLE_GRANT'  , UPPER('&&1') ) from dual ;

spool off

SET FEEDBACK    ON
SET PAGESIZE    200

-- vim:set ft=plsql:

