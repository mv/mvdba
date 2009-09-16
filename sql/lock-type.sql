/*
  script:   verlocks.sql
  objetivo: 
  autor:    Josivan
  data:     
*/
 
set echo off 
set pagesize 60 
--
Column SID         FORMAT 999 heading "Sess|ID " 
COLUMN OBJECT_NAME FORMAT A17 heading "OBJ NAME or|TRANS_ID" Trunc 
COLUMN OSUSER      FORMAT A10 heading "Op Sys|User ID" 
COLUMN USERNAME    FORMAT A8 
COLUMN TERMINAL    FORMAT A8  trunc 
--
  select B.SID
        ,C.USERNAME
        ,C.OSUSER
        ,C.TERMINAL
        ,DECODE(B.ID2, 0, A.OBJECT_NAME
                     ,'Trans-'||to_char(B.ID1)) OBJECT_NAME
        ,B.TYPE
        ,DECODE(B.LMODE,0,'--Waiting--', 
                        1,'Null', 
                        2,'Row Share', 
                        3,'Row Excl', 
                        4,'Share', 
                        5,'Sha Row Exc', 
                        6,'Exclusive', 
                          'Other') "Lock Mode"
        ,DECODE(B.REQUEST,0,' ', 
                        1,'Null', 
                        2,'Row Share', 
                        3,'Row Excl', 
                        4,'Share', 
                        5,'Sha Row Exc', 
                        6,'Exclusive', 
                          'Other') "Req Mode"
    from DBA_OBJECTS A
        ,V$LOCK B
        ,V$SESSION C 
   where A.OBJECT_ID(+) = B.ID1 
     and B.SID          = C.SID 
     and C.USERNAME is not null 
order by B.SID, B.ID2
/
