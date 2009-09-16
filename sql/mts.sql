select sess.username
      ,sess.status
      ,cir.queue       "Query Location"
      ,dis.name        "Disp Name"
      ,dis.status      "Disp Status"
      ,ss.name         "Serv Name"
      ,ss.status       "Serv Status"
  from v$circuit cir
      ,v$session sess
      ,v$dispatcher dis
      ,v$shared_server ss
where sess.saddr     = cir.saddr
  and cir.dispatcher = dis.paddr
  and cir.server     = ss.paddr(+)
/
