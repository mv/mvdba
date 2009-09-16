column cmd format a200

select 'alter database datafile '||chr(39)|| file_name ||chr(39)||' autoextend on maxsize 1900M; ' cmd
from dba_data_files
where file_name like '%log%'
/
