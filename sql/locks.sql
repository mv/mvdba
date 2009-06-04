SELECT o.owner
     , o.object_name
     , o.object_type
     , o.last_ddl_time
     , o.status
     , l.session_id
     , l.oracle_username
     , l.locked_mode
  FROM dba_objects o, gv$locked_object l
 WHERE o.object_id = l.object_id
 ORDER BY 1,3,2