set linesize 200

col PHYRDS format 999,999,999
col PHYWRTS format 999,999,999
col READTIM format 999,999,999
col WRITETIM format 999,999,999
col name format a50

ttitle "Disk Balancing Report"

select name
     , phyrds
     , phywrts
     , readtim
     , writetim
  from v$filestat a, v$dbfile b
 where a.file# = b.file#
 order by readtim desc, phywrts, phyrds

spool fio1.out
/
spool off


