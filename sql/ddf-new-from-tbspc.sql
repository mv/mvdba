select DISTINCT 'create tablespace '||rpad(tablespace_name,10,'  ')
    || ' datafile '||rpad(chr(39)||'F:\ESMBD\oradata\orains01\ddf.imp\'||lower(tablespace_name)||'.dbf'||chr(39),30,' ')
    || ' size 500M autoextend on '
    || ' extent management local uniform size 128k;'
  from dba_data_files
 where tablespace_name like 'TS%'
 order by 1
     ;     

create tablespace TSDAR      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsdar.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSDBO      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsdbo.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSDCB      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsdcb.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSDCC      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsdcc.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSDCF      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsdcf.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSDCT      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsdct.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSDCV      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsdcv.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSDHB      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsdhb.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSDOMF     datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsdomf.dbf'   size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSDSC      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsdsc.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSDSW      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsdsw.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSIAR      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsiar.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSIBO      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsibo.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSICB      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsicb.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSICC      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsicc.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSICF      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsicf.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSICT      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsict.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSICV      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsicv.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSIOMF     datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsiomf.dbf'   size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSISC      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsisc.dbf'    size 500M autoextend on  extent management local uniform size 128k;
create tablespace TSISW      datafile 'F:\ESMBD\oradata\orains01\ddf.imp\tsisw.dbf'    size 500M autoextend on  extent management local uniform size 128k;

