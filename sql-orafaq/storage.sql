SELECT d.tablespace_name "Name"
     , d.status "Status"
     ,   TO_CHAR((a.bytes / 1024 / 1024),'99,999,990.900') "Size (M)"
     ,   TO_CHAR((a.bytes / 1024 / 1024),'99,999,990.900') "Size (M)"
     ,   TO_CHAR(((a.bytes - DECODE(f.bytes, NULL, 0, f.bytes)) / 1024 / 1024),'99,999,990.900') "Used (M)"
  FROM sys.dba_tablespaces d
     , sys.sm$ts_avail a
     , sys.sm$ts_free f
 WHERE d.tablespace_name = a.tablespace_name
   AND f.tablespace_name (+) = d.tablespace_name

SELECT d.file_name "Name"
     , d.tablespace_name "Tablespace"
     , v.status "Status"
     ,   TO_CHAR((d.bytes / 1024 / 1024), '99999990.000') "Size (M)"
     ,   TO_CHAR((d.bytes / 1024 / 1024), '99999990.000') "Size (M)"
     ,   NVL(TO_CHAR(((d.bytes - SUM(s.bytes)) / 1024 / 1024), '99999990.000')
     ,      TO_CHAR((d.bytes / 1024 / 1024), '99999990.000')) "Used (M)"
  FROM sys.dba_data_files d
     , sys.dba_free_space s
     , sys.v_$datafile v
 WHERE (s.file_id (+)= d.file_id)
   AND (d.file_name = v.name)
 GROUP BY d.file_name
        , d.tablespace_name
        , v.status
        , d.bytes