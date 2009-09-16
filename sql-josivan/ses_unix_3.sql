rem *************************************************************************
rem USERS.SQL
rem
rem  This script was tested on Oracle7 V71523, OpenVMS 6.2, with users
rem  connected via Novel LAN/Windows 3.1, dial-up Windows95, and to other
rem  OpenVMS nodes in the cluster.
rem
rem  Information displayed is:
rem
rem  Process ID - if SQL*Net connected, will be the PID of the ORA_TNSnnnnn
rem  machine    - displayed only if user is accessing this node from
rem               a different machine via SQL*Net 
rem  O/S name   - host userid
rem  terminal   - terminal_id if interactive, including Windows
rem             - Batch/Det if a batch or detached process
rem  orauser    - ORACLE username if different from O/S name
rem  command    - ORACLE command being executed ('typical' commands decoded)
rem  program    - program name being run with 'extraneous' info removed
rem
rem *************************************************************************

column node noprint NEW_VALUE current_node format a1 trunc
set termout on

rem
rem Get the machine name from a 'native' task running on the node where
rem the instance we are looking into is running.  This permits you to
rem run this script remotely and still have only the non-native nodes
rem displayed in the output for easier identification.
rem
rem I think in V7.3 of ORACLE7 you can more directly access the machine
rem name which would simplify this script.
rem

select s.machine node
  from v$session s
      ,v$process p
 where p.spid = s.process          -- ensure user is running on this machine
   and machine is not null         -- skip over instance background tasks
   and rownum=1                    -- return only one row 
/
set termout on
--
column command format a14
column program format a23
column identity format a39 heading 'PID OSname:Terminal:ORAname'
--
set pagesize 60
set veri off
--
  select p.spid ||' '||decode(s.machine,'&CURRENT_NODE',null,null,'Lan:',s.machine||':')
                || s.osuser ||'<'|| decode(s.terminal,null,'Batch/Det',s.terminal)
                ||'>'||decode(s.username,s.osuser,null,s.username) identity
        ,decode(s.command,  1,'CRE TAB',
         2,'INSERT',
         3,'SELECT',
         6,'UPDATE',
         7,'DELETE',
         9,'CRE INDEX',
         12,'DROP TABLE', 
         15,'ALT TABLE', 
         39,'CRE TBLSPC', 
         42,'ALT SESSION', 
         44,'COMMIT', 
         45,'ROLLBACK', 
         47,'PL/SQL EXEC', 
         48,'SET XACTN', 
         62,'ANALYZE TAB', 
         63,'ANALYZE IX', 
         71,'CREATE MLOG', 
         74,'CREATE SNAP', 
         79,'ALTER ROLE',
         85,'TRUNC TAB',
         to_char(s.command)) command
        ,substr(s.program,instr(s.program,']',-1)+1,
         decode(instr(s.program,'.',-1) - instr(s.program,']',-1)-1,-1,99,
         instr(s.program,'.',-1) - instr(s.program,']',-1)-1)) Program
    from v$session s
        ,v$process p
   where s.type  <> 'BACKGROUND'
     and s.paddr = p.addr
     and s.program is not null
order by s.osuser
/
set veri on



