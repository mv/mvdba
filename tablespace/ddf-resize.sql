--
-- Template
--

select DISTINCT 'alter database  '||rpad(tablespace_name,10,'  ')
    || ' datafile '||rpad(chr(39)||'F:\ESMBD\oradata\orains01\ddf.imp\'||lower(tablespace_name)||'.dbf'||chr(39),30,' ')
    || ' size 2G autoextend on maxsize 4G;'
  from dba_data_files
 where tablespace_name like 'TS%'
 order by 1
   rename to ;


-- alter database datafile 'G:\ESMBD\oradata\orains01\temp.dbf'      size 2G autoextend on maxsize 4G;
-- alter database datafile 'G:\ESMBD\oradata\orains01\undotbs01.dbf' size 2G autoextend on maxsize 4G;

