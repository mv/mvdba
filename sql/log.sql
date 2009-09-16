
column group#   format 99
column member   format a50
column bytes    format 999g999g999
column Mbytes   format 999g999
column members   format 99
column status_l format a10
column first_change#    format 999g999g999g999g999

SELECT f.group#
     , f.status         status_f
     , f.member
     , l.sequence#
     , l.bytes
     , l.bytes/1024/1024 MBytes
     , l.members
     , l.status         status_l
     , l.first_change#
     , TO_CHAR(first_time, 'dd/mm/yyyy hh24:mi:ss') first_time
     , l.thread#
  FROM v$logfile f
     , v$log     l
 WHERE f.group# = l.group#
 ORDER BY 1,3
/

