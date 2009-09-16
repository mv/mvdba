
col     sid             format 999
col     username        format a15      heading 'User Name'
col     sql_text        format a50      heading 'Locking SQL Statement'
 
select a.sid
      ,a.username
      ,b.sql_text
  from v$session a
      ,v$sqlarea b
 where a.sql_address = b.address
   and a.sql_hash_value = b.hash_value
-- and a.sid = &Session_Id;
 

