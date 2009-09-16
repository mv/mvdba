set pagesize 100
--
col comando  format a15
col username format a25
--
  select username
        ,status
        ,decode(command,2,'INSERT'
                       ,3, 'SELECT'
                       ,6, 'UPDATE'
                       ,7, 'DELETE'
                         ,  command ) comando
        ,logon_time 
    from v$session 
   where username is not null
order by 1 
/
