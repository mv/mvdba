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

select dbms_metadata.get_ddl( 'TABLESPACE' , tablespace_name )
  from dba_tablespaces
 where 1=1
 order by tablespace_name
/

select dbms_metadata.get_ddl( 'USER' , username )
  from dba_users
 where 1=1
 order by username
/

select dbms_metadata.get_ddl( 'ROLE' , ROLE )
  from dba_roles
 where 1=1
 order by role
/

select dbms_metadata.get_ddl( 'DB_LINK' , db_link )
  from dba_db_links
 where 1=1
 order by db_link
/

spool off

SET FEEDBACK    ON
SET PAGESIZE    200

-- vim:set ft=plsql:

