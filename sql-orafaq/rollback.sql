rem $DBA/rollback.sql
rem
rem Displays rollback statistics for the specified database
rem
rem Passed:
rem	&1 = Oracle SID.
rem
rem <<<<<<<<<< MODIFICATION HISTORY >>>>>>>>>>
rem   Date	Programmer	Description
rem 11/04/98	Brian Lomasky	Fix error in rollback contention calculations
rem				  for system and user undo headers and blocks.
rem 12/13/95	Brian Lomasky	Original
rem
set pagesize 1000
set verify off
set head off
set echo off
set termout off
set feedback off
set newpage 1
set linesize 80
define cr=chr(10)
col lrd new_value log_reads
select sum(value) lrd from v$sysstat
where name in ('db block gets','consistent gets');
rem
spool rollback.lis
ttitle center 'ROLLBACK STATISTICS for ' &1 skip 1
ttitle off
select 'GETS  - # of gets on the rollback segment header: '||sum(gets)||&cr||
	'WAITS - # of waits for the rollback segment header: '||sum(waits)||
	&cr||'The ratio of Rollback waits/gets is '||
	round((sum(waits) / (sum(gets) + .00000001)) * 100,2)||'%'||&cr||
	'  If ratio is more than 1%, create more rollback segments'
	from v$rollstat;
col name format a6 heading "Roll|Segm|Name"
col waits format 9999 heading "Wait"
col pct_wait format 999 heading "%|Wait"
col gets format a5 heading "Gets"
col writes format a5 heading "Write"
col v1 format 999 heading 'Mb'
col v2 format 999 heading 'Opt|Mb'
col v3 format 999 heading 'Hi|Wtr|Mb'
col shrinks format 999 heading '#|Shr|ink'
col extends format 999 heading '#|Ext|end'
col aveactive format a5 heading 'Avgsz|Activ'
col extents format 999 heading '#|Ext'
col xacts format 999 heading '#|Trn'
col wraps format 999 heading "Wr|aps"
col aveshrink format 999 heading "Av|Shr"
set heading on
select name,
	waits,
	floor(100 * waits / gets) pct_wait,
	decode(sign(9999999-gets), -1, lpad(trunc(gets / 1000000), 3)||' M',
		decode(sign(9999-gets), -1, lpad(trunc(gets / 1000), 3)||' k',
			lpad(gets, 5))) gets,
	decode(sign(9999999-writes), -1, lpad(trunc(writes / 1000000), 3)||' M',
		decode(sign(9999-writes),-1,lpad(trunc(writes / 1000), 3)||' k',
			lpad(writes, 5))) writes,
	rssize / 1048576 v1,
	optsize /1048576 v2,
	hwmsize / 1048576 v3,
	shrinks,
	extends,
	decode(sign(9999999-aveactive), -1,
		lpad(trunc(aveactive / 1000000), 3)||' M',
		decode(sign(9999-aveactive), -1,
		lpad(trunc(aveactive / 1000), 3)||' k',
		lpad(aveactive, 5))) aveactive,
	extents,
	xacts,
	wraps,
	aveshrink
	from v$rollstat, v$rollname
	where v$rollstat.usn = v$rollname.usn;
col name format a6 heading "Roll|Segm|Name"
col tablespace_name format a6 heading "Tablsp"
col status format a16 heading "Status"
set heading on
select name,
	tablespace_name,
	v$rollstat.status status
	from v$rollstat, v$rollname, dba_rollback_segs
	where v$rollstat.usn = v$rollname.usn and name = segment_name and
	v$rollstat.status <> 'ONLINE';
set heading off
select 'If # Shrink is low:'||&cr||
	'    If AvShr is low:'||&cr||
	'        If Avgsz Activ is much smaller than Opt Mb:'||&cr||
	'            Reduce OPTIMAL (since not many shrinks occur).'||&cr||
	'    If AvShr is high:'||&cr||
	'        Good value for OPTIMAL.'||&cr||
	'If # Shrink is high:'||&cr||
	'    If AvShr is low:'||&cr||
	'        Too many shrinks being performed, since OPTIMAL is'||&cr||
	'        somewhat (but not hugely) too small.'||&cr||
	'    If AvShr is high:'||&cr||
	'        Increase OPTIMAL until # of Shrnk decreases.  Periodic'||&cr||
	'        long transactions are probably causing this.'||&cr||&cr||
	'A high value in the #Ext column indicates dynamic extension, in'||&cr||
	'which case you should consider increasing your rollback segment'||&cr||
	'size.  (Also, increase it if you get a "Shapshot too old" error).'||
	&cr||&cr||
	'A high value in the # Extend and # Shrink columns indicate'||&cr||
	'allocation and deallocation of extents, due to rollback segments'||
	&cr||'with a smaller optimal size.  It also may be due to a batch'||&cr
	||'processing transaction assigned to a smaller rollback segment.'||&cr
	||'Consider increasing OPTIMAL.'
	from dual;
column so noprint
select 1 so, 'Rollback contention for system undo header = '||
	(round(max(decode(class, 'system undo header', count, 0)) /
	(&log_reads+0.00000000001),4))*100||'%'||
	'   (Total reads = '||&log_reads||')'
	from v$waitstat
union
select 2 so, 'Rollback contention for system undo block  = '||
	(round(max(decode(class, 'system undo block', count, 0)) /
	(&log_reads+0.00000000001),4))*100||'%'||
	'   (Total reads = '||&log_reads||')'
	from v$waitstat
union
select 3 so, 'Rollback contention for undo header        = '||
	(round(max(decode(class, 'undo header', count, 0)) /
	(&log_reads+0.00000000001),4))*100||'%'||
	'   (Total reads = '||&log_reads||')'
	from v$waitstat
union
select 4 so, 'Rollback contention for undo block         = '||
	(round(max(decode(class, 'undo block', count, 0)) /
	(&log_reads+0.00000000001),4))*100||'%'||
	'   (Total reads = '||&log_reads||')'
	from v$waitstat
union
select 5 so, 'If percentage is more than 1%, create more rollback segments'
	from dual
	order by 1;
spool off
exit
