/*
  SCRIPT:   SES_LOCK_1.SQL
  OBJETIVO: LISTA AS SESSOES COM LOCK NO BANCO
  AUTOR:    JOSIVAN
  DATA:     2000.02.09   
*/

--
-- # Assunto...: Consulta de lock´s no banco.                                #
--
col object_name  format a30
col schemaname   format a15
col object_type  format a12
--
  select a.sid
        ,d.osuser
        ,d.schemaname
        ,a.type
        ,c.object_type
        ,a.id1
        ,decode(a.lmode,1,NULL
                       ,2,'ROW SHARE'
                       ,3,'ROW EXCLUSIVE'
                       ,4,'SHARE'
                       ,5,'SHARE ROW EXCLUSIVE'
                       ,6,'EXCLUSIVE','NONE') LMODE
        ,decode(a.request,1,NULL
                         ,2,'ROW SHARE'
                         ,3,'ROW EXCLUSIVE'
                         ,4,'SHARE'
                         ,5,'SHARE ROW EXCLUSIVE'
                         ,6,'EXCLUSIVE','NONE') LREQUEST
        ,c.object_name
    from v$lock a
        ,dba_objects c
        ,v$session d
   where a.sid   =d.sid
     and a.id1   =c.object_id(+)
     and d.osuser is not null
order by 1
/
