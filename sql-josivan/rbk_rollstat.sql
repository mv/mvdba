/*
  script:   rbk_rollstat.sql
  objetivo: 
  autor:    Josivan
  data:     
*/
--
col rssize  format 999,999,999
col extents format 999,999,999
col hwmsize format 999,999,999
col optsize format 999,999,999
--
select usn
      ,RSSIZE
      ,EXTENTS
      ,HWMSIZE
      ,OPTSIZE
      ,waits
  from v$rollstat
/
