--
-- Template
--

select DISTINCT 'alter database  '||rpad(tablespace_name,10,'  ')
    || ' datafile '||rpad(chr(39)||'F:\ESMBD\oradata\orains01\ddf.imp\'||lower(tablespace_name)||'.dbf'||chr(39),30,' ')
    || ' size 500M autoextend on '
    || ' extent management local uniform size 128k;'
  from dba_data_files
 where tablespace_name like 'TS%'
 order by 1
   rename to ;

-- alter database rename file 'F:\ESMBD\oradata\orains01\tsdar.dbf'  to 'M:\ESMBD\oradata\orains01\tsdar.dbf'  ;
-- alter database rename file 'F:\ESMBD\oradata\orains01\tsdbo.dbf'  to 'M:\ESMBD\oradata\orains01\tsdbo.dbf'  ;
-- alter database rename file 'F:\ESMBD\oradata\orains01\tsdcb.dbf'  to 'M:\ESMBD\oradata\orains01\tsdcb.dbf'  ;

ALTER DATABASE datafile 'G:\ESMBD\oradata\orains01\temp.dbf'    size 15G autoextend off;
ALTER DATABASE datafile 'G:\ESMBD\oradata\orains01\undotbs01.dbf' autoextend on ; --size 20G ;

