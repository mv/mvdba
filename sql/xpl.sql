
select lpad(' ', 2*(level-1))
    || operation || ' '
    || options   || ' '
    || object_name || ' '
    || decode(id, 0, 'Cost = ' || position) "Query Plan"
  from plan_table
 start with id = 0
        and statement_id = 'mv'
connect by prior id = parent_id
             and statement_id = 'mv'
/
