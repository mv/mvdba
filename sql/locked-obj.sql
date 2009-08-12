SELECT DECODE(request,0,'Holder: ','Waiter: ') || l.sid sess
     , serial#
     , id1
     , id2
     , lmode
     , request
     , l.type
  FROM gv$lock   l
     , v$session s
 WHERE (id1, id2, l.type) IN ( SELECT id1, id2, type 
                                 FROM gv$lock 
                                WHERE request>0)
   AND l.sid = s.sid
 ORDER BY id1, request;