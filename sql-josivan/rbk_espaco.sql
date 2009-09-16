/*
  script:   rbk_espaco.sql
  objetivo: segmentos x espaco disponivel
  autor:    josivan
  data:     
*/

column tablespace_name format a14
column segment_type    format a8 
column segment_name    format a30
column bytes           format 999,999,999,999
column extents         format 999
--
set pages 50
--
clear screen
--
ttitle center "Relatorio Segment x Space" skip 2
--
break on tablespace_name on segment_type
--
  select tablespace_name
        ,segment_type
        ,substr(segment_name,1,20) segmento
        ,extents  
        ,bytes/1024/1024 mb
    from sys.dba_segments
    where bytes>80000000 or extents > 30
order by tablespace_name
        ,segment_type
        ,bytes
/
ttitle off
