
-- conn system/aquarius@belohorizonte

set linesize 200
set pagesize 0

spool /tmp/alter_index.sql

select 'alter index '||owner||'.'||RPAD(index_name,30,' ')
       ||' rebuild tablespace '
       ||decode(SUBSTR(tablespace_name,1,3) , 'INF','INFRA_INDX_01'
                                            , 'FED','FED_INDX_01'
                                            ,  tablespace_name
                                            )
       ||' storage (initial 128k next 128k maxextents 4096) '
       ||';'
from dba_indexes
where status <> 'VALID'
/

spool off

-- @/tmp/alter_index.sql

-- @C:\work\dba\move\rb_idx.sql

