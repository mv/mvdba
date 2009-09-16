column column_name format a30
column owner format a10

select cols.owner
     , cols.constraint_name
     , cols.table_name
     , cols.position
     , cols.column_name
  from user_cons_columns   cols
     , user_constraints    cons
 where constraint_type IN ('C')
   and cols.constraint_name = cons.constraint_name
 order by cols.table_name
        , cols.column_name

/
