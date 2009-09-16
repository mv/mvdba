set linesize 100
set pagesize 200
column parameter format a20 heading 'Data Dictionary Area'
column gets format 999,999,999 heading 'Total|Requests'
column getmisses format 999,999,999 heading 'Misses'
column modifications format 999,999 heading 'Mods'
column flushes format 999,999 heading 'Flushes'
column getmiss_ratio format 9.99 heading 'Miss|Ratio'
ttitle 'Shared Pool Row Cache Usage'

select parameter
     , gets
     , getmisses
     , modifications
     , flushes
     ,(getmisses / decode(gets,0,1,gets)) getmiss_ratio
     , decode(trunc((getmisses / decode(gets,0,1,gets)),1),.0,' ','*') " "
  from v$rowcache
 where Gets + GetMisses <> 0
 order by gets desc
/
