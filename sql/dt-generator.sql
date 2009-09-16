-- $Id: dt_generator.sql 18665 2007-08-22 18:37:24Z marcus.ferreira $
-- $URL: http://aurora.alejandro.inf.br:8080/repos/mdias/salto/branch/marcus.ferreira/sql/dt_generator.sql $
-- http://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:14582643282111

variable start_date VARCHAR2(25)
variable end_date   VARCHAR2(25)
exec :start_date := '2003/12/01'; :end_date := '2003/12/03';


--
-- Intervalo de dias
--
SELECT dtg.d                                      dt
     , TO_CHAR(dtg.d, 'dd/mm/yyyy hh24:mi:ss')    dt_24h
     , TO_CHAR(dtg.d, 'yyyy-mm-dd hh24:mi:ss')    dt_iso
  FROM (
         SELECT TO_DATE(:start_date,'yyyy/mm/dd') + (ROWNUM)- 1 AS d
           FROM ALL_OBJECTS
          WHERE ROWNUM <= (TO_DATE(:end_date  ,'yyyy/mm/dd') - TO_DATE(:start_date,'yyyy/mm/dd') + 1.99999)
        ) dtg
ORDER BY 1
/


--
-- Intervalo de horas
--
SELECT dtg.d                                      dt
     , TO_CHAR(dtg.d, 'dd/mm/yyyy hh24:mi:ss')    dt_24h
     , TO_CHAR(dtg.d, 'yyyy-mm-dd hh24:mi:ss')    dt_iso
  FROM (
         SELECT TO_DATE(:start_date,'yyyy/mm/dd') + (ROWNUM * 1/24 )- 1 AS d
           FROM ALL_OBJECTS
          WHERE ROWNUM <= (TO_DATE(:end_date  ,'yyyy/mm/dd') - TO_DATE(:start_date,'yyyy/mm/dd') + 1.99999)
                          * 24
        ) dtg
ORDER BY 1
/


--
-- Intervalo de 10 min
--
SELECT dtg.d                                      dt
     , TO_CHAR(dtg.d, 'dd/mm/yyyy hh24:mi:ss')    dt_24h
     , TO_CHAR(dtg.d, 'yyyy-mm-dd hh24:mi:ss')    dt_iso
  FROM (
         SELECT TO_DATE(:start_date,'yyyy/mm/dd') + (ROWNUM * 1/24/60*10 )- 1 AS d
           FROM ALL_OBJECTS
          WHERE ROWNUM <= (TO_DATE(:end_date  ,'yyyy/mm/dd') - TO_DATE(:start_date,'yyyy/mm/dd') + 1.99999)
                          * 24
                          * 60/10
        ) dtg
ORDER BY 1
/


