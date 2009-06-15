/* $Header: sqlareas.sql 238684.1 2003/11/21 12:00:00 pkm ship $ */
SET DOC OFF;
/*============================================================================+
|    Copyright (c) 2003 Oracle Corporation Redwood Shores, California, USA    |
|                              All rights reserved.                           |
+=============================================================================+
|
| FILENAME
|
|   sqlarea-stat.sql - SQL Area Statistics
|
|
| USAGE
|
|   Reports SQL Area and Shared Pool Statistics
|
|   Connect into SQL*Plus as USER who installed and executes the 'SQL Area Top
|   DML' script sqlareat.sql.
|   If used on an Oracle Applications database, connect as APPS.  Otherwise,
|   connect as SYSTEM.
|
|      SQL> START sqlarea-stat.sql;
|
|
| DESCRIPTION
|
|   The 'SQL Area Statistics' script reports valuable shared pool and SQL Area
|    statistics.
|
|   This script can be used on databases with RDBMS 8.1.6 or higher and it is
|   not constrained to Oracle Apps.
|
|   There is one seeded parameter:
|
|   1. p_top: With a default of 10, this parameter indicates how many DML
|      commands should be extracted out of the V$SQLAREA. (i.e. Top x), when
|      displaying top SQL with same first 60 char.
|
|
| NOTES
|
|   This script is part of a set compressed into file SQLA.zip.  Latest version
|   of SQLA.zip can be downloaded from Note:238684.1
|
|   Read Note:238684.1 for further details.
|
|
+============================================================================*/


PRO
PRO ***                                                              ***
PRO *** sqlarea-stat.sql - SQL Area Statistics                           ***
PRO ***                                                              ***
PRO *** Generating spool file.  Please wait a few minutes            ***
PRO ***                                                              ***
PRO

SET VER OFF FEED OFF SERVEROUT ON SIZE 1000000;

DEF p_top                = 10

VAR v_cpu_count          VARCHAR2(10);
VAR v_database           VARCHAR2(40);
VAR v_instance           VARCHAR2(40);
VAR v_platform           VARCHAR2(40);
VAR v_rdbms_release      VARCHAR2(17);
VAR v_top                NUMBER;
VAR v_startup_time       VARCHAR2(20);

CL BRE COL COMP;
COL c_cpu_count          NOPRI NEW_V c_cpu_count          FOR A10;
COL c_database           NOPRI NEW_V c_database           FOR A40;
COL c_instance           NOPRI NEW_V c_instance           FOR A40;
COL c_platform           NOPRI NEW_V c_platform           FOR A40;
COL c_rdbms_release      NOPRI NEW_V c_rdbms_release      FOR A17;
COL c_sysdate            NOPRI NEW_V c_sysdate            FOR A20;
COL c_startup_time       NOPRI NEW_V c_startup_time       FOR A20;

COL exec_count                 FOR 9999999999   HEA 'EXECUTIONS|COUNT';
COL ghratio                    FOR A7           HEA 'GET HIT|  RATIO';
COL invalidations              FOR 99999        HEA 'INVAL';
COL module_action              FOR A50;
COL num_exec                   FOR A4           HEA 'NUM.|EXEC';
COL parameter                  FOR A35;
COL phratio                    FOR A7           HEA 'PIN HIT|  RATIO';
COL pool_size                  FOR 99999999     HEA 'SIZE(MB)';
COL sql_count_60               FOR 9999999999   HEA 'COUNT';
COL sql_text_60                FOR A60          HEA 'SQL_TEXT FIRST 60 CHAR';
COL value                      FOR A15;

EXEC DBMS_APPLICATION_INFO.SET_MODULE('sqlarea-stat.sql', 'REPORTING');

BEGIN
   :v_top               := TO_NUMBER( '&&p_top' );
END;
/

EXEC SQLA$.ENV(:v_platform, :v_database, :v_instance, :v_startup_time, :v_rdbms_release, :v_cpu_count);

SELECT :v_platform      c_platform,
       :v_database      c_database,
       :v_instance      c_instance,
       :v_startup_time  c_startup_time,
       :v_rdbms_release c_rdbms_release,
       :v_cpu_count     c_cpu_count,
       TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI')
                        c_sysdate
  FROM DUAL;

SET TERM OFF PAGES 50000 LIN 32000 NUM 14 VER OFF FEED OFF TRIMS ON RECSEP OFF;
SET SERVEROUT ON SIZE 1000000 LONG 600000 AUTOTRACE OFF;

--- spool file
SPO sqlarea-stat.html;

PRO <html><head><title>Sqlarea-Stat.html</title>
PRO <style type="text/css">
PRO h1  { font-family:Arial,Helvetica,Geneva,sans-serif;font-size:16pt }
PRO h2  { font-family:Arial,Helvetica,Geneva,sans-serif;font-size:12pt }
PRO h3  { font-family:Arial,Helvetica,Geneva,sans-serif;font-size:10pt }
PRO pre { font-family:Courier New,Geneva;font-size:8pt }
PRO </style></head><body><pre>
PRO <h1>sqlarea-stat.sql - SQL Area Statistics</h1>

SET DEF '~';
PRO METALINK_NOTE       = <a title="MetaLink Note:238684.1" target="_blank" href="http://metalink.oracle.com/metalink/plsql/showdoc?db=NOT&id=238684.1">238684.1</a>
SET DEF ON;

PRO PLATFORM            = &&c_platform
PRO DATABASE            = &&c_database
PRO INSTANCE            = &&c_instance
PRO STARTUP_TIME        = &&c_startup_time
PRO RDBMS_RELEASE       = &&c_rdbms_release
PRO CPU_COUNT           = &&c_cpu_count
PRO
PRO P_TOP               = &&p_top

PRO
PRO
PRO <h2>V$LIBRARYCACHE (BETWEEN &&c_startup_time AND &&c_sysdate)</h2>
SELECT namespace,
       gets,
       gethits,
       SUBSTR(TO_CHAR(ROUND(gethitratio*100,1),'9990.0'),1,7) ghratio,
       pins,
       pinhits,
       SUBSTR(TO_CHAR(ROUND(pinhitratio*100,1),'9990.0'),1,7) phratio,
       reloads,
       invalidations
  FROM v$librarycache;

PRO
PRO
PRO <h2>SHARED POOL - SGA</h2>
SELECT name,
       ROUND(bytes/1048576) pool_size
  FROM v$sgastat
 WHERE pool = 'shared pool'
   AND bytes > 1048576
 ORDER BY 2 DESC;

PRO
PRO
PRO <h2>SHARED POOL - PARAMETERS</h2>
SELECT SUBSTR(name,1,35)  parameter,
       SUBSTR(value,1,15) value
  FROM v$parameter
 WHERE name LIKE '%shared%pool%';

PRO
PRO
EXEC SQLA$.PUT_JUST_STARS;

PRO
PRO
PRO <h2>SQL DISTRIBUTION PER NUMBER OF EXECUTIONS</h2>
SELECT LPAD(DECODE(DECODE(executions,0,0,1,1,2),0,'0',1,'1','>1'),4) num_exec,
       COUNT(*) exec_count
  FROM v$sqlarea
 GROUP BY
       DECODE(executions,0,0,1,1,2);

PRO
PRO
PRO <h2>TOP SQL WITH SAME FIRST 60 CHARACTERS</h2>
SET DEF '~';
SELECT *
  FROM ( SELECT /*+ NO_MERGE */
                REPLACE(REPLACE(SUBSTR(sql_text,1,60),'>','&gt;'),'<','&lt;') sql_text_60,
                COUNT(*) sql_count_60,
                SUBSTR(module||' - '||action,1,50) module_action
           FROM v$sqlarea
          GROUP BY
                SUBSTR(sql_text,1,60),
                SUBSTR(module||' - '||action,1,50)
         HAVING COUNT(*) > 1
          ORDER BY
                2 DESC )
 WHERE ROWNUM < :v_top+1;
SET DEF ON;

PRO
PRO
EXEC SQLA$.PUT_JUST_STARS;

SPO OFF;

EXEC DBMS_APPLICATION_INFO.SET_MODULE(NULL, NULL);
CL BRE COL COMP;
SET TERM ON PAGES 24 LIN 80 NUM 10 VER ON FEED 6 TRIMS OFF RECSEP WR;
SET SERVEROUT OFF LONG 80 DOC ON;
PRO sqlarea-stat.html has been generated
UNDEF p_top c_cpu_count c_database c_instance c_platform c_rdbms_release c_sysdate c_startup_time

