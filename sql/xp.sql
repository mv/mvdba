select LPad(' ', 2*(Level-1))
    || Level || '.' || Nvl(Position,0)|| ' '
    || Operation || ' '
    || Options || ' '
    || LOWER(Object_Name) || ' '
    || LOWER(Object_Type) || ' '
    || Decode(id, 0, Statement_Id ||' Cost = ' || Position)
--  || Other || ' '
    || Object_Node "Query Plan"
  from plan_table
 start with id = 0
        and statement_id = 'mv'
 connect by prior id = parent_id
    and statement_id = 'mv'
/

