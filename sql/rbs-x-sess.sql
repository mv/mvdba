SELECT r.name "ROLLBACK SEGMENT NAME "
     , p.pid "ORACLE PID"
     , p.spid "SYSTEM PID "
     , NVL(p.username, 'NO TRANSACTION')
     , p.terminal
  FROM v$lock l, v$process p, v$rollname r
 WHERE l.sid = p.pid(+) 
   AND TRUNC(l.id1(+) / 65536) = r.usn 
   AND l.type(+) = 'TX' 
   AND l.lmode(+) = 6
 ORDER BY r.name;