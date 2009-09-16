
set numformat 999g999g990

column latch format a40
column name format a40

column "WTW Perc" format 0d00
column "IMM Perc" format 0d00

select Name "Latch"
     , Sum(Gets) "WTW Gets"
     , Sum(Misses) "WTW Misses"
     , Sum(Misses)/DECODE( Sum(Gets)
                         , 0, 1
                         , Sum(Gets)) *100 "WTW Perc"
     , Sum(Immediate_Gets) "IMM Gets"
     , Sum(Immediate_Misses) "IMM Misses"
     , Sum(Immediate_Misses)/DECODE( Sum(Immediate_Gets)
                                   , 0, 1
                                   , Sum(Immediate_Gets)) *100  "IMM Perc"
  from V$Latch
 where Name Like 'redo%'
    or immediate_gets>0
    or immediate_misses>0
 group by Name;
