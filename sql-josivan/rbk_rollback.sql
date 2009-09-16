/*
  SCRIPT:   rbk_rollback
  OBJETIVO: LISTAR OS SEGMENTOS DE ROLLBACK ONLINE
  AUTOR:    JOSIVAN
  DATA:     2000.02.08   
*/

  select r.name                 rollseg
        ,s.username             username
        ,s.sid
        ,s.serial#
        ,p.spid                 UNIX
        ,substr(s.machine,1,15) machine
    from v$transaction t
        ,v$rollname r
        ,v$process p
        ,v$session s
   where t.addr   = s.taddr
     and t.xidusn = r.usn
     and s.paddr  = p.addr
order by 1,2
/

