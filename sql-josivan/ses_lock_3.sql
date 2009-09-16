/*
  script:   ses_lock_2.sql
  objetivo: verifica lock de tabelas
  autor:    Josivan
  data:     
*/

host clear
prompt --- Aguarde, verificando tabelas em lock 
prompt 
--
col sid         format 999 
col username    format a12 heading 'USUARIO|ORACLE'
col type        format a4  heading 'TYPE'
col id1         format 9999999
col object_name format a25 heading 'NOME DO OBJETO'
col object_type format a8  heading 'TIPO DO|OBJETO'
col lmode       format 99
col osuser      format a8  heading 'USUARIO|UNIX'
--
select t1.sid
      ,t3.username
      ,t1.type
      ,t1.id1
      ,t2.object_name
      ,t2.object_type
      ,t1.lmode
      ,t3.osuser
 from v$lock t1
     ,sys.dba_objects t2
     ,v$session t3
where t1.id1 = t2.object_id
  and t1.sid = t3.sid
  and t3.username is not null
/

