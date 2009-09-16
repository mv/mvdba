set linesize 200
set numformat 999g999g999g999d00

show parameter db_name

select (1 - (   sum(decode(name, 'physical reads' ,value,0)) /
              ( sum(decode(name, 'db block gets'  ,value,0)) +
                sum(decode(name, 'consistent gets',value,0))
              )
            )
        ) * 100 "Buffer Hit Ratio"
      , sum(decode(name, 'physical reads' ,value,0)) "physical reads"
      , sum(decode(name, 'db block gets'  ,value,0)) "db block gets"
      , sum(decode(name, 'consistent gets',value,0)) "consistent gets"
from v$sysstat
/

select (1 - (sum(getmisses)/sum(gets))
        ) * 100 "Dict. Hit Ratio"
     , sum(getmisses) "Row cache get misses"
     , sum(gets)      "Row cache gets"
from v$rowcache
/

select Sum(Pins) / (Sum(Pins)+Sum(Reloads)) * 100 "Lib. Hit Ratio"
     , sum(pins)    "Lib. pins"
     , sum(reloads) "Lib. reloads"
from v$librarycache
/

col bytes for 999,999,999,999 heading "Free Bytes"

select to_number(v$parameter.value) "shared_pool_size"
     , v$sgastat.bytes
     , (v$sgastat.bytes/to_number(v$parameter.value))*100 "Percent Free"
  from v$sgastat
     , v$parameter
where v$sgastat.name = 'free memory'
  and v$sgastat.pool = 'shared pool'
  and v$parameter.name = 'shared_pool_size'
/

select to_number(v$parameter.value) "java_pool_size"
     , v$sgastat.bytes
     , (v$sgastat.bytes/to_number(v$parameter.value))*100 "Percent Free"
  from v$sgastat
     , v$parameter
where v$sgastat.name = 'free memory'
  and v$sgastat.pool = 'java pool'
  and v$parameter.name = 'java_pool_size'
/

select to_number(v$parameter.value) "large_pool_size"
     , v$sgastat.bytes
     , (v$sgastat.bytes/to_number(v$parameter.value))*100 "Percent Free"
  from v$sgastat
     , v$parameter
where v$sgastat.name = 'free memory'
  and v$sgastat.pool = 'large pool'
  and v$parameter.name = 'large_pool_size'
/

show parameter sort_area_size

select a.value "Disk Sorts"
     , b.value "Memory Sorts"
     , round(100*(b.value/decode((a.value+b.value)
                                , 0,1
                                ,(a.value+b.value))
                  )
            , 2 ) "Pct Memory Sorts"
  from v$sysstat a, v$sysstat b
 where a.name = 'sorts (disk)'
   and b.name = 'sorts (memory)'
/

set linesize 50
