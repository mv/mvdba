/*
  SCRIPT:   SES_ATIVA_1.SQL
  OBJETIVO: LISTAR TODOS OS USUARIOS CONECTADOS AO BANCO
  AUTOR:    JOSIVAN
  DATA:     2000.02.09   
*/

select sid
      ,serial#
      ,osuser
      ,program
      ,status 
  from v$session
/

  select s.sid
        ,s.serial#
        ,p.spid       UNIX
        ,s.username
        ,s.osuser
        ,substr(s.machine,1,15) machine 
    from v$process p
        ,v$session s
   where s.paddr=p.addr
order by 5
/

