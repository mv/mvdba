select syn.*
     , obj.object_type
     , obj.object_name
  from user_synonyms syn
     , all_objects   obj
 where syn.table_owner = obj.owner (+)
   and syn.table_name  = obj.object_name (+)
   and obj.object_name is null
 order by syn.synonym_name
        , obj.object_type
        , obj.object_name
     ;
