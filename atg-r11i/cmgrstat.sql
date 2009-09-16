-- $Id: cmgrstat.sql 8438 2007-01-25 14:18:47Z marcus.ferreira $
-- http://www.orafaq.com/scripts/apps/cmgrstat.txt
rem -----------------------------------------------------------------------
rem Filename:   appinfo.sql
rem Purpose:    Script to display status of all the Concurrent Managers
rem Author:     Anonymous
rem -----------------------------------------------------------------------

set head on

column OsId       format A10 justify left
column CpId       format 999999
column Opid       format 999
column Manager    format A30
column Status     format A20
column Started_At format A30

column Cpid       heading 'Concurrent|Process ID'
column OsId       heading 'System|Process ID'
column Opid       heading 'Oracle|Process ID'
column Manager    heading 'Concurrent Manager Name'
column Status     heading 'Status|of Concurrent|Manager'
column Started_At heading 'Concurrent Manager|Started at'

select distinct Concurrent_Process_Id CpId, PID Opid,
       Os_Process_ID Osid, Q.Concurrent_Queue_Name Manager,
       P.process_status_code Status,
       To_Char(P.Process_Start_Date, 'MM-DD-YYYY HH:MI:SSAM') Started_At
from   Fnd_Concurrent_Processes P, Fnd_Concurrent_Queues Q, FND_V$Process
where  Q.Application_Id = Queue_Application_ID
  and  Q.Concurrent_Queue_ID = P.Concurrent_Queue_ID
  and  Spid = Os_Process_ID
  and  Process_Status_Code not in ('K','S')
order  by Concurrent_Process_ID, Os_Process_Id, Q.Concurrent_Queue_Name
/
