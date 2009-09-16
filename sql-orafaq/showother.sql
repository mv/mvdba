rem This is the showother.sql query and shows all processes with no session

select substr(spid,1,6) SRVPID
     , username
     , program
  from v$process
  where BACKGROUND <> 1
    and ADDR not in (select paddr
                      from v$session)
/

