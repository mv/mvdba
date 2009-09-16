SELECT name, bytes, kbytes, mbytes
  FROM (
    select name
         , value                    bytes
         , ROUND(value/1024,2)      kbytes
         , ROUND(value/1024/1024,2) mbytes 
      from v$sga
    UNION
    select 'Total System Global Area' as name
         , SUM(value)                    bytes
         , ROUND(SUM(value)/1024,2)      kbytes
         , ROUND(SUM(value)/1024/1024,2) mbytes 
      from v$sga
)
order by decode( name
               , 'Total System Global Area' , 1
               , 'Fixed Size'               , 2
               , 'Variable Size'            , 3
               , 'Database Buffers'         , 4
               , 'Redo Buffers'             , 5
               )
/


