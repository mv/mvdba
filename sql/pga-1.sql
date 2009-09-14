/* sga + pga allocated */ select sum(bytes)/1024/1024 Mb from
      (select bytes from v$sgastat
        union
        select value bytes from
             v$sesstat s,
             v$statname n
        where
             n.STATISTIC# = s.STATISTIC# and
             n.name = 'session pga memory'
       );
       
       
/* pga/uga by sid */ select
   sid,name, TO_CHAR(value/1024/1024,'999g999g990d00')   as mega
from
   v$statname n,v$sesstat s
where
   n.STATISTIC# = s.STATISTIC# and
   name like 'session%memory%'
order by 3 desc




/* max pga */ select -- 771,90M
                sum(value)/1024/1024 Mb
             from
                 v$sesstat s, v$statname n
              where
                  n.STATISTIC# = s.STATISTIC# and
                  name = 'session pga memory';
                  
                  
                  