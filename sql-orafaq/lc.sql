set numwidth 3
set space 2
set newpage 0
set pagesize 58
set linesize 80
set tab off
set echo off

ttitle 'Shared Pool Library Cache Usage'

column namespace format a20 heading ' '
column pins format 999,999,999 heading 'Executions'
column pinhits format 999,999,999 heading 'Hits'
column pinhitratio format 9.99 heading 'Hit|Ratio'
column reloads format 999,999 heading 'Reloads'
column reloadratio format .9999 heading 'Reload|Ratio'
spool cache_lib.lis

select namespace
     , pins
     , pinhits
     , pinhitratio
     , reloads
     , reloads/decode(pins,0,1,pins) reloadratio
  from v$librarycache
/

spool off
