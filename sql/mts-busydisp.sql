--------------------------------------------------------------------------------
-- Filename:	busydisp.sql
-- Purpose:	provides stats indicating whether or not the dispatcher
--		processes are overly taxed.
--------------------------------------------------------------------------------

column network	heading "Protocol"				format a40
column rate	heading "Total Busy Rate|>50%=>Add Dispatchers"	format 99.99

set head off 
set feedback off 

 
SELECT  sysdate 
FROM    dual 
/ 
set head on 
set feedback on 



SELECT	network,
	status,
	100*(sum(busy)/(sum(busy)+sum(idle))) rate
FROM	v$dispatcher
GROUP BY network, status
/

SELECT	network,
	100*(sum(busy)/(sum(busy)+sum(idle))) rate
FROM	v$dispatcher
GROUP BY network
/

col name format a5
col owned form 9,999
col status format a10
col bytes format 999,999,999,999 heading "bytes"
col messages format 999,999,999
col biz format 999,999,999 heading "Busy|(secs)"

select name, status, owned, breaks, bytes, messages, busy/100 biz
from v$dispatcher
/


column protocol	heading "Protocol"				format a40
column Wait	heading "Average Wait|(hundredths of seconds)"	format a30

                         
SELECT	network Protocol,
	decode( sum(totalq), 0, 'No Responses',
	to_char(sum(wait)/sum(totalq), 'FM9999.90')) Wait
FROM	v$queue q, v$dispatcher d
WHERE	q.type = 'DISPATCHER'
AND 	q.paddr = d.paddr
GROUP BY network
/
