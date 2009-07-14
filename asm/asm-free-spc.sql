--
-- ORACLE_HOME=+ASM sqlplus sys as sysdba
--
--
-- ORACLE_HOME=ORA_ASM_HOME
-- $ asmcmd
-- cmd> lsdg
--

select group_number
     , disk_number
     , state
     , total_mb
     , free_mb
     , round(1-(free_mb/total_mb),2)*100 perc_used
     , name
     , path
  from v$asm_disk
 where name is not null
 order by 1,2

