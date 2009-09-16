--------------------------------------------------------------------------------
-- Filename:	busyq.sql
-- Purpose:	provides stats indicating whether or not a given queue
--		is overly taxed in a Multi-Threaded Server environment.
--		If the COMMON queue is overly taxed, consider adding more
--		servers.
-- Author:	cdye@excite.com
--------------------------------------------------------------------------------

column type	heading "Queue|Type"			format a10
column circuit	heading "Name"				format a8
column queued	heading "Items|Queued"			format 999,999
column wait	heading "Total|Time|Waited"		format 999,999,999,999
column totalq	heading "Total|Items|Processed"		format 999,999,999,999
column avgwait	heading "Average|Wait"			format 9,999.90

set head off 
set feedback off 

SELECT  sysdate 
FROM    dual 
/ 
set head on 
set feedback on 

SELECT	paddr,
	type,
	queued,
	wait,
	totalq,
	decode(totalq, 0, 0, wait)/decode(totalq, 0, 1, totalq) avgwait
FROM	v$queue
/
