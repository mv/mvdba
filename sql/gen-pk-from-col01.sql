selec 'alter table '||RPAD(t.table_name, 31, ' ')
    ||' add constraint '||RPAD('pk_'||REPLACE(t.table_name,'PV_',NULL),30,' ')
    ||' primary key '||RPAD('('||c.column_name||')',30,' ')
    ||' ; --'||c.column_id
  from dba_tables       t
     , dba_tab_columns  c
 where t.owner='PORTALV_DONO'
   and t.table_name NOT IN (SELECT cons.table_name
                              FROM dba_constraints cons
                             WHERE cons.owner='PORTALV_DONO'
                               AND constraint_type='P'
                             )
   and t.table_name = c.table_name
   and c.column_name like 'COD%'
  order by t.table_name, c.column_id
     ;

