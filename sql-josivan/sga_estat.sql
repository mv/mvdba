/*
  script:   sga_estat.sql
  objetivo: script para obter memoria alocada, memoria livre e percentual livre
  autor:    josivan
  data:     
*/
--
set echo off
--
select name
      ,sgasize/1024/1024            "Usados(M)"
      ,bytes/1024/1024              "Livres(M)"
      ,round((bytes/sgasize)*100,2) "%SGA Livre"
  from sys.v_$sgastat f
      ,(select sum(bytes) sgasize
          from sys.v_$sgastat) s
 where f.name = 'free memory'
/
