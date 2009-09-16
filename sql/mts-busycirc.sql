--------------------------------------------------------------------------------
-- Filename:	busycirc.sql
-- Purpose:	provides stats indicating whether or not a given circuit
--		is overly taxed in a Multi-Threaded Server environment
--------------------------------------------------------------------------------

column server	heading "Server"			format a8
column circuit	heading "Name"				format a8
column status	heading "Status"			format a8
column message0	heading "Bytes|in|First|Msg|Buf"	format 9,999
column message1	heading "Bytes|in|Second|Msg|Buf"	format 9,999
column messages	heading "Messages|Processed"		format 9,999,999
column queue	heading "Queue"				format a10
column bytes	heading "Bytes"				format 99,999,999
column breaks	heading "Brks"				format 999

set head off
set feedback off

SELECT	sysdate
FROM	dual
/
set head on
set feedback on


SELECT	server,
	circuit,
	status,
	queue,
	message0,
	message1,
	messages,
	bytes,
	breaks
FROM	v$circuit
ORDER BY server
/
