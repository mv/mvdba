/* $Header: sqlareat.sql 238684.1 2003/12/01 12:00:00 pkm ship $ */
SET DOC OFF;
/*============================================================================+
|    Copyright (c) 2003 Oracle Corporation Redwood Shores, California, USA    |
|                              All rights reserved.                           |
+=============================================================================+
|
| FILENAME
|
|   sqlarea-top.sql - SQL Area, Plan and Statistics for Top DML (Logical/Physical)
|
|
| USAGE
|
|   Reports V$SQLAREA, V$SQL_PLAN, V$SQL_PLAN_STATISTICS and V$SQL_WORKAREA for
|   Top x DML commands according to BUFFER_GETS and DISK_READS (logical and
|   physical reads)
|
|   Connect into SQL*Plus as USER who will be executing the 'SQL Area Top DML'
|   If used on an Oracle Applications database, connect as APPS.  Otherwise,
|   connect as main application user whith access to most schema objects
|   including DBA and V$ views.  It can also be installed and used connecting
|   as SYSTEM, but Explain Plans on 8i will not be generated for application
|   code.
|
|      SQL> START sqlarea-top.sql;
|
|
| DESCRIPTION
|
|   The 'SQL Area, Plan and Statistics for Top DML' script finds the Top x DML
|   commands in terms of logical and physical reads, reporting the SQL text,
|   explain plan, and basic CBO stats for tables and indexes.
|
|   This script can be used on databases with RDBMS 8.1.6 or higher and it is
|   not constrained to Oracle Apps.
|
|   There are two seeded parameters:
|
|   1. p_top: With a default of 10, this parameter indicates how many DML
|      commands should be extracted out of the V$SQLAREA. (i.e. Top x)
|
|   2. p_days_to_keep_repo: With a default of 30, it indicates how many days of
|      historical data to keep in the repository.  Rows older than this
|      parameter are automatically deleted.
|
|
| NOTES
|
|   This script is part of a set compressed into file SQLA.zip.  Latest version
|   of SQLA.zip can be downloaded from Note:238684.1
|
|   When used for the first time, sqlarea-top.sql executes automatically the
|   installation script sqlacrea.sql.  The latter executes other scripts in
|   order to create a staging repository and one package.  If used in UNIX,
|   keep all script filenames in UPPERCASE.
|
|   If re-installing or installing manually, execute script sqlacrea.sql to
|   create the schema objects required by sqlarea-top.sql.
|
|   If you need to uninstall this tool, execute commands below and remove
|   scripts SQLA* from dedicated directory.
|
|      SQL> START sqladrop.sql;
|
|   Read Note:238684.1 for further details.
|
|
+============================================================================*/


PRO
PRO ***                                                                             ***
PRO *** sqlarea-top.sql - SQL Area, Plan and Statistics for Top DML (Logical/Physical) ***
PRO ***                                                                             ***
PRO *** Generating spool file.  Please wait a few minutes                           ***
PRO ***                                                                             ***
PRO

SET VER OFF FEED OFF SERVEROUT ON SIZE 1000000;

DEF p_top                = 10
DEF p_days_to_keep_repo  = 30

VAR v_cpu_count          VARCHAR2(10);
VAR v_database           VARCHAR2(40);
VAR v_instance           VARCHAR2(40);
VAR v_platform           VARCHAR2(40);
VAR v_rdbms_release      VARCHAR2(17);
VAR v_script             VARCHAR2(30);
VAR v_snap_id            NUMBER;
VAR v_top                NUMBER;
VAR v_startup_time       VARCHAR2(20);

CL BRE COL COMP;
COL c_cpu_count          NOPRI NEW_V c_cpu_count          FOR A10;
COL c_database           NOPRI NEW_V c_database           FOR A40;
COL c_instance           NOPRI NEW_V c_instance           FOR A40;
COL c_platform           NOPRI NEW_V c_platform           FOR A40;
COL c_rdbms_release      NOPRI NEW_V c_rdbms_release      FOR A17;
COL c_script             NOPRI NEW_V c_script             FOR A40;
COL c_snap_id            NOPRI NEW_V c_snap_id            FOR A10;
COL c_sysdate            NOPRI NEW_V c_sysdate            FOR A20;
COL c_startup_time       NOPRI NEW_V c_startup_time       FOR A20;


COL buffer_gets                FOR 999999999999;
COL child_number               FOR 99999        HEA 'CHILD';
COL command                    FOR A7;
COL cpu_seconds                FOR A11;
COL details                    FOR A30;
COL disk_reads                 FOR 999999999999;
COL elapsed_sec                FOR A11;
COL executions                 FOR 9999999999   HEA 'EXECUTIONS';
COL fetches                    FOR 9999999999   HEA 'FETCHES';
COL ghratio                    FOR A7           HEA 'GET HIT|  RATIO';
COL invalidations              FOR 99999        HEA 'INVAL';
COL loads                      FOR 99999;
COL module_action              FOR A50;
COL parameter                  FOR A35;
COL parse_calls                FOR 9999999999   HEA 'PARSES';
COL parsing_user               FOR A15;
COL phratio                    FOR A7           HEA 'PIN HIT|  RATIO';
COL pool_size                  FOR 99999999     HEA 'SIZE(MB)';
COL rows_processed             FOR 999999999999 HEA 'ROWS';
COL sharable_mem               FOR 99999999999;
COL sorts                      FOR 99999;
COL top                        FOR 999;
COL value                      FOR A15;
COL version_count              FOR 99999        HEA 'VERSN';

EXEC DBMS_APPLICATION_INFO.SET_MODULE('sqlarea-top.sql', 'EXTRACTING');

DECLARE
    l_count NUMBER;
BEGIN
   :v_top               := TO_NUMBER( '&&p_top' );

   SELECT COUNT(*)
     INTO l_count
     FROM user_source
    WHERE name        = 'SQLA$'
      AND type        = 'PACKAGE BODY'
      AND line        = 2
      AND text        LIKE '%2003/12/01%';

    IF l_count = 1 THEN
       :v_script := 'sqlarea-purge.sql &&p_days_to_keep_repo';
    ELSE
       :v_script := 'create/sqlacrea.sql';
    END IF;
END;
/

SELECT :v_script c_script FROM DUAL;
@@&&c_script

BEGIN
   SELECT sqla$snap_seq.NEXTVAL INTO :v_snap_id FROM DUAL;
   INSERT INTO sqla$snap VALUES (:v_snap_id, SYSDATE);
   COMMIT;
END;
/

EXEC SQLA$.ENV(:v_platform, :v_database, :v_instance, :v_startup_time, :v_rdbms_release, :v_cpu_count);

SELECT LPAD(TO_CHAR(:v_snap_id), 4, '0')
                        c_snap_id,
       :v_platform      c_platform,
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
SPOOL sqlarea-top_&&c_snap_id..html;

PRO <html><head><title>sqlarea-top&&c_snap_id..html</title>
PRO <style type="text/css">
PRO h1  { font-family:Arial,Helvetica,Geneva,sans-serif;font-size:16pt }
PRO h2  { font-family:Arial,Helvetica,Geneva,sans-serif;font-size:12pt }
PRO h3  { font-family:Arial,Helvetica,Geneva,sans-serif;font-size:10pt }
PRO pre { font-family:Courier New,Geneva;font-size:8pt }
PRO </style></head><body><pre>
PRO <h1>sqlarea-top.sql - SQL Area, Plan and Statistics for Top DML (Logical/Physical)</h1>

EXEC SQLA$.SNAPSHOT_TOP(:v_snap_id, :v_top);
EXEC DBMS_APPLICATION_INFO.SET_MODULE('sqlarea-top.sql', 'REPORTING');

SET DEF '~';
PRO METALINK_NOTE       = <a title="MetaLink Note:238684.1" target="_blank" href="http://metalink.oracle.com/metalink/plsql/showdoc?db=NOT&id=238684.1">238684.1</a>
SET DEF ON;

PRO
PRO PLATFORM            = &&c_platform
PRO DATABASE            = &&c_database
PRO INSTANCE            = &&c_instance
PRO STARTUP_TIME        = &&c_startup_time
PRO RDBMS_RELEASE       = &&c_rdbms_release
PRO CPU_COUNT           = &&c_cpu_count
PRO
PRO P_TOP               = &&p_top
PRO P_DAYS_TO_KEEP_REPO = &&p_days_to_keep_repo
PRO
PRO SNAPSHOT_ID         = &&c_snap_id (&&c_sysdate)

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
PRO <h2>SQL AREA TOP DML COMMANDS IN TERMS OF BUFFER_GETS AND DISK_READS (AS OF &&c_sysdate)</h2>

SELECT sa.top,
       sa.buffer_gets,
       sa.disk_reads,
       LPAD(TO_CHAR(ROUND(sa.cpu_time/1000000,2), 'FM9999990.00'), 11) cpu_seconds,
       LPAD(TO_CHAR(ROUND(sa.elapsed_time/1000000,2), 'FM9999990.00'), 11) elapsed_sec,
       sa.sharable_mem,
       sa.invalidations,
       sa.loads,
       sa.sorts,
       ( SELECT SUBSTR(username, 1, 15)
           FROM dba_users u
          WHERE sa.parsing_user_id = u.user_id ) parsing_user,
       sa.version_count,
       '<a href="#'||TO_CHAR(sa.snap_id)||'-'||TO_CHAR(sa.top)||'">details</a>' details
  FROM sqla$sqlarea sa
 WHERE :v_rdbms_release  NOT LIKE '8%'
   AND sa.snap_id         = :v_snap_id
 ORDER BY
       sa.top;

SELECT sa.top,
       sa.parse_calls,
       sa.executions,
       sa.fetches,
       sa.rows_processed,
       SUBSTR(sa.module||' - '||sa.action, 1, 50) module_action,
       ( SELECT SUBSTR(name, 1, 7)
           FROM audit_actions aa
          WHERE sa.command_type = aa.action ) command,
       '<a href="#'||TO_CHAR(sa.snap_id)||'-'||TO_CHAR(sa.top)||'">details</a>' details
  FROM sqla$sqlarea sa
 WHERE :v_rdbms_release  NOT LIKE '8%'
   AND sa.snap_id         = :v_snap_id
 ORDER BY
       sa.top;

SELECT sa.top,
       sa.buffer_gets,
       sa.disk_reads,
       sa.sharable_mem,
       sa.invalidations,
       sa.loads,
       sa.sorts,
       ( SELECT SUBSTR(username, 1, 15)
           FROM dba_users u
          WHERE sa.parsing_user_id = u.user_id ) parsing_user,
       sa.version_count,
       '<a href="#'||TO_CHAR(sa.snap_id)||'-'||TO_CHAR(sa.top)||'">details</a>' details
  FROM sqla$sqlarea sa
 WHERE :v_rdbms_release  LIKE '8%'
   AND sa.snap_id         = :v_snap_id
 ORDER BY
       sa.top;

SELECT sa.top,
       sa.parse_calls,
       sa.executions,
       sa.rows_processed,
       SUBSTR(sa.module||' - '||sa.action, 1, 50) module_action,
       ( SELECT SUBSTR(name, 1, 7)
           FROM audit_actions aa
          WHERE sa.command_type = aa.action ) command,
       '<a href="#'||TO_CHAR(sa.snap_id)||'-'||TO_CHAR(sa.top)||'">details</a>' details
  FROM sqla$sqlarea sa
 WHERE :v_rdbms_release  LIKE '8%'
   AND sa.snap_id         = :v_snap_id
 ORDER BY
       sa.top;

SELECT s.top,
       s.child_number,
       s.buffer_gets,
       s.disk_reads,
       LPAD(TO_CHAR(ROUND(s.cpu_time/1000000,2), 'FM9999990.00'), 11) cpu_seconds,
       LPAD(TO_CHAR(ROUND(s.elapsed_time/1000000,2), 'FM9999990.00'), 11) elapsed_sec,
       s.sharable_mem,
       s.invalidations,
       s.loads,
       s.sorts,
       ( SELECT SUBSTR(username, 1, 15)
           FROM dba_users u
          WHERE s.parsing_user_id = u.user_id ) parsing_user,
       '<a href="#'||TO_CHAR(sa.snap_id)||'-'||TO_CHAR(sa.top)||'">details</a>' details
  FROM sqla$sql     s,
       sqla$sqlarea sa
 WHERE :v_rdbms_release  NOT LIKE '8%'
   AND s.snap_id         = :v_snap_id
   AND s.snap_id         = sa.snap_id
   AND s.top             = sa.top
   AND sa.version_count  > 1
 ORDER BY
       s.top,
       s.child_number;

SELECT s.top,
       s.child_number,
       s.parse_calls,
       s.executions,
       s.fetches,
       s.rows_processed,
       SUBSTR(s.module||' - '||s.action, 1, 50) module_action,
       '<a href="#'||TO_CHAR(sa.snap_id)||'-'||TO_CHAR(sa.top)||'">details</a>' details
  FROM sqla$sql     s,
       sqla$sqlarea sa
 WHERE :v_rdbms_release  NOT LIKE '8%'
   AND s.snap_id         = :v_snap_id
   AND s.snap_id         = sa.snap_id
   AND s.top             = sa.top
   AND sa.version_count  > 1
 ORDER BY
       s.top,
       s.child_number;

EXEC SQLA$.PUT_CURSORS_SNAP(:v_snap_id);

PRO </pre></body></html>
SPO OFF;

EXEC DBMS_APPLICATION_INFO.SET_MODULE(NULL, NULL);
CL BRE COL COMP;
SET TERM ON PAGES 24 LIN 80 NUM 10 VER ON FEED 6 TRIMS OFF RECSEP WR;
SET SERVEROUT OFF LONG 80 DOC ON;
PRO sqlarea-top&&c_snap_id..html has been generated
UNDEF p_top p_days_to_keep_repo c_cpu_count c_database c_instance c_platform c_rdbms_release
UNDEF c_script c_snap_id c_sysdate c_startup_time

