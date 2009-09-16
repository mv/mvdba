/*
  SCRIPT:   SES_OBJ_LOCK.SQL
  OBJETIVO: LISTAR OS OBJETOS TRAVADOS PELO USUARIO
  AUTOR:    JOSIVAN
  DATA:     2000.02.08   
*/
SELECT VLO.SESSION_ID
      ,VLO.ORACLE_USERNAME
      ,VLO.OS_USER_NAME
      ,DECODE(VLO.LOCKED_MODE,'0','NENHUM'
                             ,'1','NULO'
                             ,'2','LINHA'
                             ,'3','LINHA'
                             ,'4','PARTILHA'
                             ,'5','LINHA UNICA'
                             ,'6','EXCLUSIVO')
      ,SUBSTR(AO.OBJECT_NAME,1,20) OBJETO
  FROM V$LOCKED_OBJECT VLO
      ,DBA_OBJECTS AO
 WHERE VLO.OBJECT_ID = AO.OBJECT_ID
/


COL BLOCKING_OTHERS FORMAT A15
COL SID FORMAT 999999
--
  SELECT SESSION_ID SID
        ,NAME
        ,MODE_HELD
        ,MODE_REQUESTED
        ,BLOCKING_OTHERS        
    FROM SYS.DBA_DML_LOCKS
ORDER BY SESSION_ID
/
