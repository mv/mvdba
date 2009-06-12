--
-- Template: new tbspcs
--

select DISTINCT 'create tablespace '||rpad(tablespace_name,10,'  ')
    || ' datafile '||rpad(chr(39)||'F:\ESMBD\oradata\orains01\ddf.imp\'||lower(tablespace_name)||'.dbf'||chr(39),30,' ')
    || ' size 500M autoextend on '
    || ' extent management local uniform size 128k;'
  from dba_data_files
 where tablespace_name like 'TS%'
 order by 1
     ;     

-- create tablespace TSDAR      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsdar.dbf'    size 500M autoextend on  extent management local uniform size 128k;
-- create tablespace TSDBO      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsdbo.dbf'    size 500M autoextend on  extent management local uniform size 128k;
-- create tablespace TSDCB      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsdcb.dbf'    size 500M autoextend on  extent management local uniform size 128k;

