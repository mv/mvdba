Rem SID    = Session identifierRem SER = Session serial number
Rem OSUER  = Operating system username
Rem OSPID  = Operating system process identifier
Rem STAT   = Status of session (ACT=active INA=Inactive)
Rem COM    = Command number.  Definition listed in table Audit_actions
Rem SCHEMA = Oracle username
Rem TYP    = Type of process (USE=user BAC=background)
Rem %HIT   = Hit ratio in percent
Rem CPU    = CPU being used
Rem BCHNG  = Block changes
Rem CCHNG  = Consistent changes
--
set lines 150
--
select substr(s.sid,1,3)       sid
      ,substr(s.serial#,1,5)   ser
      ,substr(osuser,1,8)      osuser
      ,spid                    ospid
      ,substr(status,1,3)      stat
      ,substr(command,1,3)     com
      ,substr(schemaname,1,10) schema
      ,substr(type,1,3)        typ
      ,substr(decode((consistent_gets+block_gets),0,'None',
                     (100*(consistent_gets+block_gets-physical_reads)/(consistent_gets+block_gets))),1,4) 
                      "%HIT",value CPU,substr(block_changes,1,5) bchng
      ,substr(consistent_changes,1,5) cchng
  from v$process p
      ,v$sesstat t
      ,v$sess_io i
      ,v$session s
 where i.sid       =s.sid
   and p.addr      =paddr(+)
   and s.sid       =t.sid
   and t.statistic#=12
/
