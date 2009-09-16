set feedback off
set verify off
set echo off
--
clear screen
--
ttitle left "Base de Dados Conectado" Skip 1 -
       left '=======================' Skip 2
--
col name     heading "Instancia"
col log_mode heading "Historico"
--
select name
      ,log_mode
  from v$database;
--
col rssize format 999,999,999
col extents format 999
col hwmsize format 999,999,999
col optsize format 999,999,999
col Rollback format a8
--
ttitle center "Situacao dos Segmentos de RollBack" Skip 1 -
       center '==================================' Skip 2
--
select a.segment_name Rollback
      ,b.usn
      ,b.rssize
      ,b.extents
      ,b.hwmsize
      ,b.optsize
      ,b.waits
  from v$rollstat b
      ,dba_rollback_segs a
 where a.segment_id = b.usn
/
ttitle off
set feedback on
set verify on
set echo on
