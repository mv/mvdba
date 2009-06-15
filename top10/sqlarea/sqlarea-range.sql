/* $Header: sqlarear.sql 238684.1 2003/11/21 12:00:00 pkm ship $ */
SET DOC OFF;
/*============================================================================+
|    Copyright (c) 2003 Oracle Corporation Redwood Shores, California, USA    |
|                              All rights reserved.                           |
+=============================================================================+
|
| FILENAME
|
|   sqlarea-range.sql - SQL Area, Plan and Statistics for Top DML (range of snaps)
|
|
| USAGE
|
|   Reports V$SQLAREA, V$SQL_PLAN, V$SQL_PLAN_STATISTICS and V$SQL_WORKAREA for
|   Top x DML commands according to BUFFER_GETS and DISK_READS (logical and
|   physical reads) for a range of snaps created by sqlareat.sql.
|
|   Connect into SQL*Plus as USER who executes the 'SQL Area Top DML' scripts.
|   If used on an Oracle Applications database, connect as APPS.  Otherwise,
|   connect as main application user whith access to most schema objects
|   including DBA and V$ views.  It can also be installed and used connecting
|   as SYSTEM, but Explain Plans on 8i will not be generated for application
|   code.
|
|      SQL> START sqlarea-range.sql <p_process_type> <p_snap_id_from> <p_snap_id_to>;
|
|
| DESCRIPTION
|
|   The 'SQL Area, Plan and Statistics for Top DML' script finds the Top x DML
|   for a range of snaps created by the sqlareat.sql, reporting the SQL text,
|   explain plan, and basic CBO stats for tables and indexes.
|
|   This script can be used on databases with RDBMS 8.1.6 or higher and it is
|   not constrained to Oracle Apps.
|
|   This script has three user parameters:
|
|   1. p_process_type: Enter LR to report expensive SQL in terms of Logical
|       Reads, or PR for Physical Reads.  Default is LR.
|
|   2. p_snap_id_from.  Default is 1.
|
|   3. p_snap_id_to.  Default is 9999.
|
|   There is one seeded parameter:
|
|   1. p_top: With a default of 10, this parameter indicates how many DML
|      commands should be extracted from range of snaps (i.e. Top x)
|
|
| NOTES
|
|   This script is part of a set compressed into file SQLA.zip.  Latest version
|   of SQLA.zip can be downloaded from Note:238684.1
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
PRO *** sqlarea-range.sql - SQL Area, Plan and Statistics for Top DML (range of snaps)   ***
PRO ***                                                                             ***
SELECT snap_id,
       TO_CHAR(creation_date, 'YYYY-MON-DD HH24:MI') snap_date
  FROM sqla$snap
 ORDER BY
       snap_id;
PRO
PRO Parameter 1: PROCESS TYPE <LR> (for logical reads) or <PR> (for physical reads)
PRO Parameter 2: SNAP_ID FROM
PRO Parameter 3: SNAP_ID TO
PRO

SET VER OFF FEED OFF SERVEROUT ON SIZE 1000000;

DEF p_top                = 10

DEF p_process_type       = '&1'

PRO
DEF p_snap_id_from       = '&2'
DEF p_snap_id_to         = '&3'

PRO ***                                                                             ***
PRO *** Generating spool file.  Please wait a few minutes                           ***
PRO ***                                                                             ***

VAR v_process_type       VARCHAR2(2);
VAR v_cpu_count          VARCHAR2(10);
VAR v_database           VARCHAR2(40);
VAR v_instance           VARCHAR2(40);
VAR v_platform           VARCHAR2(40);
VAR v_range_id           NUMBER;
VAR v_rdbms_release      VARCHAR2(17);
VAR v_script             VARCHAR2(30);
VAR v_snap_id            NUMBER;
VAR v_snap_id_from       NUMBER;
VAR v_snap_id_to         NUMBER;
VAR v_top                NUMBER;
VAR v_startup_time       VARCHAR2(20);

CL BRE COL COMP;
COL c_process_type       NOPRI NEW_V c_process_type       FOR A40;
COL c_cpu_count          NOPRI NEW_V c_cpu_count          FOR A10;
COL c_database           NOPRI NEW_V c_database           FOR A40;
COL c_instance           NOPRI NEW_V c_instance           FOR A40;
COL c_platform           NOPRI NEW_V c_platform           FOR A40;
COL c_range_id           NOPRI NEW_V c_range_id           FOR A10;
COL c_rdbms_release      NOPRI NEW_V c_rdbms_release      FOR A17;
COL c_snap_id_from       NOPRI NEW_V c_snap_id_from       FOR A40;
COL c_snap_id_to         NOPRI NEW_V c_snap_id_to         FOR A40;
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
COL snap_id                    FOR 9999         HEA 'SNAP';
COL sorts                      FOR 99999;
COL top                        FOR 9999         HEA 'TOP|SNAP';
COL top_range                  FOR 9999         HEA 'TOP|RANGE';
COL value                      FOR A15;
COL version_count              FOR 99999        HEA 'VERSN';

EXEC DBMS_APPLICATION_INFO.SET_MODULE('sqlarea-range.sql', 'EXTRACTING');

BEGIN
   :v_top               := TO_NUMBER('&&p_top');
   :v_process_type      := SUBSTR(UPPER(NVL('&&p_process_type','LR')),1,2);
   :v_snap_id_from      := TO_NUMBER(NVL('&&p_snap_id_from','0'));
   :v_snap_id_to        := TO_NUMBER(NVL('&&p_snap_id_to','9999'));
   SELECT sqla$range_seq.NEXTVAL INTO :v_range_id FROM DUAL;
END;
/

EXEC SQLA$.ENV(:v_platform, :v_database, :v_instance, :v_startup_time, :v_rdbms_release, :v_cpu_count);

SELECT LPAD(TO_CHAR(:v_range_id),4,'0')
                        c_range_id,
       LPAD(TO_CHAR(:v_snap_id_from),4,'0')||
       (SELECT TO_CHAR(creation_date, '(YYYY-MON-DD HH24:MI)')
          FROM sqla$snap
         WHERE snap_id = :v_snap_id_from)
                        c_snap_id_from,
       LPAD(TO_CHAR(:v_snap_id_to),4,'0')||
       (SELECT TO_CHAR(creation_date, '(YYYY-MON-DD HH24:MI)')
          FROM sqla$snap
         WHERE snap_id = :v_snap_id_to)
                        c_snap_id_to,
       DECODE(:v_process_type,'LR','LR (logical reads)','PR','PR (physical reads)','UNKNOWN')
                        c_process_type,
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
SPOOL sqlarea-range_&&c_range_id..html;

PRO <html><head><title>sqlarea-range&&c_range_id..html</title>
PRO <style type="text/css">
PRO h1  { font-family:Arial,Helvetica,Geneva,sans-serif;font-size:16pt }
PRO h2  { font-family:Arial,Helvetica,Geneva,sans-serif;font-size:12pt }
PRO h3  { font-family:Arial,Helvetica,Geneva,sans-serif;font-size:10pt }
PRO pre { font-family:Courier New,Geneva;font-size:8pt }
PRO </style></head><body><pre>
PRO <h1>sqlarea-range.sql - SQL Area, Plan and Statistics for Top DML (Logical/Physical)</h1>

EXEC SQLA$.RANGE(:v_range_id, :v_snap_id_from, :v_snap_id_to, :v_process_type, :v_top);
EXEC DBMS_APPLICATION_INFO.SET_MODULE('sqlarea-range.sql', 'REPORTING');

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
PRO P_PROCESS_TYPE      = &&c_process_type
PRO P_SNAP_ID_FROM      = &&c_snap_id_from
PRO P_SNAP_ID_TO        = &&c_snap_id_to
PRO
PRO SYSDATE             = &&c_sysdate

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
PRO <h2>SQL AREA TOP DML COMMANDS IN TERMS OF &&c_process_type BETWEEN SNAPS &&c_snap_id_from AND &&c_snap_id_to</h2>

SELECT r.top_range,
       sa.snap_id,
       sa.top,
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
  FROM sqla$range   r,
       sqla$sqlarea sa
 WHERE :v_rdbms_release  NOT LIKE '8%'
   AND r.range_id        = :v_range_id
   AND r.snap_id         = sa.snap_id
   AND r.top_snap        = sa.top
 ORDER BY
       r.top_range;

SELECT r.top_range,
       sa.snap_id,
       sa.top,
       sa.parse_calls,
       sa.executions,
       sa.fetches,
       sa.rows_processed,
       SUBSTR(sa.module||' - '||sa.action, 1, 50) module_action,
       ( SELECT SUBSTR(name, 1, 7)
           FROM audit_actions aa
          WHERE sa.command_type = aa.action ) command,
       '<a href="#'||TO_CHAR(sa.snap_id)||'-'||TO_CHAR(sa.top)||'">details</a>' details
  FROM sqla$range   r,
       sqla$sqlarea sa
 WHERE :v_rdbms_release  NOT LIKE '8%'
   AND r.range_id        = :v_range_id
   AND r.snap_id         = sa.snap_id
   AND r.top_snap        = sa.top
 ORDER BY
       r.top_range;

SELECT r.top_range,
       sa.snap_id,
       sa.top,
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
  FROM sqla$range   r,
       sqla$sqlarea sa
 WHERE :v_rdbms_release  LIKE '8%'
   AND r.range_id        = :v_range_id
   AND r.snap_id         = sa.snap_id
   AND r.top_snap        = sa.top
 ORDER BY
       r.top_range;

SELECT r.top_range,
       sa.snap_id,
       sa.top,
       sa.parse_calls,
       sa.executions,
       sa.rows_processed,
       SUBSTR(sa.module||' - '||sa.action, 1, 50) module_action,
       ( SELECT SUBSTR(name, 1, 7)
           FROM audit_actions aa
          WHERE sa.command_type = aa.action ) command,
       '<a href="#'||TO_CHAR(sa.snap_id)||'-'||TO_CHAR(sa.top)||'">details</a>' details
  FROM sqla$range   r,
       sqla$sqlarea sa
 WHERE :v_rdbms_release  LIKE '8%'
   AND r.range_id        = :v_range_id
   AND r.snap_id         = sa.snap_id
   AND r.top_snap        = sa.top
 ORDER BY
       r.top_range;

SELECT r.top_range,
       s.snap_id,
       s.top,
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
  FROM sqla$range   r,
       sqla$sql     s,
       sqla$sqlarea sa
 WHERE :v_rdbms_release  NOT LIKE '8%'
   AND r.range_id        = :v_range_id
   AND r.snap_id         = s.snap_id
   AND r.top_snap        = s.top
   AND s.snap_id         = sa.snap_id
   AND s.top             = sa.top
   AND sa.version_count  > 1
 ORDER BY
       r.top_range,
       s.child_number;

SELECT r.top_range,
       s.snap_id,
       s.top,
       s.child_number,
       s.parse_calls,
       s.executions,
       s.fetches,
       s.rows_processed,
       SUBSTR(s.module||' - '||s.action, 1, 50) module_action,
       '<a href="#'||TO_CHAR(sa.snap_id)||'-'||TO_CHAR(sa.top)||'">details</a>' details
  FROM sqla$range   r,
       sqla$sql     s,
       sqla$sqlarea sa
 WHERE :v_rdbms_release  NOT LIKE '8%'
   AND r.range_id        = :v_range_id
   AND r.snap_id         = s.snap_id
   AND r.top_snap        = s.top
   AND s.snap_id         = sa.snap_id
   AND s.top             = sa.top
   AND sa.version_count  > 1
 ORDER BY
       r.top_range,
       s.child_number;

EXEC SQLA$.PUT_CURSORS_RANGE(:v_range_id);

PRO </pre></body></html>
SPO OFF;

EXEC DBMS_APPLICATION_INFO.SET_MODULE(NULL, NULL);
CL BRE COL COMP;
SET TERM ON PAGES 24 LIN 80 NUM 10 VER ON FEED 6 TRIMS OFF RECSEP WR;
SET SERVEROUT OFF LONG 80 DOC ON;
PRO sqlarea-range&&c_range_id..html has been generated
UNDEF 1 2 3 p_top c_process_type c_cpu_count c_database c_instance c_platform c_range_id c_rdbms_release
UNDEF c_snap_id_from c_snap_id_to c_sysdate c_startup_time
