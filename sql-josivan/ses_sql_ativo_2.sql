/*
  SCRIPT:   SES_SQL_ATIVO_2.SQL
  OBJETIVO: LISTAR O SQL EFETUADA NO BANCO NESTE MOMENTO
  AUTOR:    JOSIVAN
  DATA:     2000.02.09   
*/

 select SQL_TEXT
       ,sid
       ,serial#
       ,osuser
       ,program
       ,status
   from v$sql
       ,v$session
  where SQL_ADDRESS = ADDRESS
/


