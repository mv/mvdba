-- $Id$
select pool, name
     , bytes
     , ROUND(bytes/1024,2) kbytes
     , ROUND(bytes/1024/1024,2) mbytes 
  from v$sgastat
 order by pool, name
/

