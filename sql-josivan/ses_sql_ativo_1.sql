/*
  SCRIPT:   SES_SQL_ATIVO_1.SQL
  OBJETIVO: RETORNA O SQL ATIVO, USUARIO, INSTANCIA
  AUTOR:    JOSIVAN
  DATA:     2000.02.08   
*/

set pagesize 24
set linesize 150
set long     500
column username                                format a10
column process        heading 'PID'            format a6                
column sid                                     format 9990  
column program                                 format a17
column sql_text                                format a64
column disk_reads     heading 'DISK|READS'     format 9999999
column buffer_gets    heading 'BUFFER|GETS'    format 9999999
column executions     heading 'EXEC'           format 99999
column ROWS_PROCESSED heading 'ROWS|PROCES'    format 9999999
--
break on username on sid skip 1 on disk_reads on buffer_gets on executions ON ROWS_PROCESSED
--
   select t.sql_text 
         ,a.username 
--       ,a.process 
         ,sid 
--       ,nvl(a.program,b.program) program 
         ,disk_reads  
         ,buffer_gets  
         ,ROWS_PROCESSED  
         ,executions
     from v$sqltext t
         ,v$sqlarea c
         ,v$session a
    where a.sql_address     =c.address(+)
      and a.sql_hash_value  =c.hash_value(+)
      and a.sql_address     =t.address(+)
      and a.sql_hash_value  =t.hash_value(+)
      and sid in (select sid
                    from v$access)
      and t.sql_text not like 'SELECT SYSDATE%'
 order by sid
         ,t.address
         ,t.hash_value
         ,t.piece
/
