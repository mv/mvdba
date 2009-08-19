
column object_name format a40

select syn.synonym_name
     , obj.object_type
     , obj.owner||'.'||obj.object_name as object_name
     , obj.status
     , obj.created
     , obj.last_ddl_time
     , syn.db_link
  from user_synonyms syn
     , all_objects   obj
 where syn.table_owner = obj.owner (+)
   and syn.table_name  = obj.object_name (+)
 order by syn.synonym_name
        , obj.object_type
        , obj.object_name
     ;
