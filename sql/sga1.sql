set linesize 200
column name     format a50
column value    format a20
set numformat 999g999g999g9990

select name, value
from v$parameter
where name in ( 'db_block_buffers'
              , 'db_block_size'
              , 'shared_pool_size'
              , 'java_pool_size'
              , 'large_pool_size'
              , 'sort_area_size'
              )
order by 1
/

set linesize 50
