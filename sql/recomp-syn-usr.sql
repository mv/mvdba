select 'CREATE OR REPLACE SYNONYM '
      ||RPAD(synonym_name, 31, ' ')
      ||' for '
      ||table_owner||'.'||RPAD(table_name,31,' ')
      ||';'
from user_synonyms
where synonym_name in
      (select object_name
         from user_objects
        where object_type='SYNONYM'
          and status <> 'VALID'
       )