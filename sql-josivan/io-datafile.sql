/*
  script:   io_datafile.sql
  objetivo: io de disco
  autor:    Josivan
  data:     
*/

set pagesize 50
--
col name format a50
--
  select name          
        ,phyrds           "Blocos Lidos"
        ,phywrts          "Blocos Gravados"
        ,(phyrds+phywrts) "Total de Blocos"
    from v$datafile a
        ,v$filestat b
   where a.file#=b.file#
order by 2 desc
/

