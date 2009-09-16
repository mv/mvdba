select 1,tablespace_name, sum(bytes/1024/1024) mega
from dba_data_files
group by tablespace_name
/
