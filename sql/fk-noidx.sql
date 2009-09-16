/*
  script:   FK_SEM_INDICE.SQL
  objetivo: IDENTIFICAR AS FKS QUE NAO POSSUEM INDICE
  autor:    Josivan
  data:     
*/

COL table_name      format A20 head 'TABLE_NAME'
COL constraint_name format A20 head 'CONSTRAINT_NAME'
COL table2          format A20 head 'TABLE_A_SER_INDEXADA'
COL column_name     format A20 head 'COLUNA_A_SER_INDEXADA'
--
set linesize 100
--
  select t.table_name
        ,c.constraint_name
        ,c.table_name table2
        ,acc.column_name
    from all_constraints t
        ,all_constraints c
        ,all_cons_columns acc
   where c.r_constraint_name = t.constraint_name
     and c.table_name        = acc.table_name
     and c.constraint_name   = acc.constraint_name
     and not exists ( select 'x'
                        from all_ind_columns aid
                       where aid.table_name  = acc.table_name
                         and aid.column_name = acc.column_name )
order by c.table_name
/
