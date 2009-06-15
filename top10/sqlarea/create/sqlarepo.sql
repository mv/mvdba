/* $Header: sqlarepo.sql 238684.1 2003/11/21 12:00:00 pkm ship $ */
SET DOC OFF;
/*============================================================================+
|    Copyright (c) 2003 Oracle Corporation Redwood Shores, California, USA    |
|                              All rights reserved.                           |
+=============================================================================+
|
| FILENAME
|
|   sqlarepo.sql - Creates Staging Repository for 'SQL Area Top DML'
|
|
| USAGE
|
|   Connect into SQL*Plus as USER who will be executing the 'SQL Area Top DML'
|   (i.e. APPS or SYSTEM)
|
|      SQL> START sqlarepo.sql;
|
|
| DESCRIPTION
|
|   This script has one seeded parameter:
|
|   1. p_tablespace: Tablespace where Staging Repository is installed.  Seeded
|                    value is Default Tablespace for USER.
|
|
| NOTES
|
|   This script is part of a set compressed into file SQLA.zip.  Latest version
|   of SQLA.zip can be downloaded from Note:238684.1
|
|   If installing on a Tablespace other than USER's Default Tablespace, simply
|   set correct Tablespace on DEF command below.  Replace <SQLA> and uncomment
|   DEF command removing double dash '--'.  Be aware that Tablespace specified
|   on DEF command must exist.
|
|   Read Note:238684.1 for further details.
|
|
+============================================================================*/


PRO
PRO Creating SQLA$ Repository
PRO

SET ECHO ON;
COL p_tablespace NOPRI NEW_V p_tablespace FOR A30;
SELECT default_tablespace p_tablespace FROM dba_users WHERE username = USER;

/* Remove double dash and specify Tablespace name if necessary                 */
-- DEF p_tablespace = SQLA


/* *************************************************************************** */

PRO Creating SQLA$ Sequences


CREATE SEQUENCE sqla$snap_seq
START WITH 1 INCREMENT BY 1 MAXVALUE 9999 MINVALUE 1 CYCLE NOCACHE;

CREATE SEQUENCE sqla$range_seq
START WITH 1 INCREMENT BY 1 MAXVALUE 9999 MINVALUE 1 CYCLE NOCACHE;


/* *************************************************************************** */

PRO Creating SQLA$ Tables


CREATE TABLE sqla$snap
(
  snap_id                    NUMBER,
  creation_date              DATE
 )
NOLOGGING TABLESPACE &&p_tablespace;


CREATE TABLE sqla$sqlarea
(
  snap_id                    NUMBER,
  top                        NUMBER,
  sql_text                   VARCHAR2(1000),
  hash_value                 NUMBER,
  address                    RAW(8),
  buffer_gets                NUMBER,
  disk_reads                 NUMBER,
  cpu_time                   NUMBER,
  elapsed_time               NUMBER,
  sharable_mem               NUMBER,
  invalidations              NUMBER,
  loads                      NUMBER,
  version_count              NUMBER,
  sorts                      NUMBER,
  parsing_user_id            NUMBER,
  parse_calls                NUMBER,
  executions                 NUMBER,
  fetches                    NUMBER,
  rows_processed             NUMBER,
  command_type               NUMBER,
  module                     VARCHAR2(64),
  action                     VARCHAR2(64),
  explain_plan_error         VARCHAR2(512)
 )
NOLOGGING TABLESPACE &&p_tablespace;


CREATE TABLE sqla$sql
(
  snap_id                    NUMBER,
  top                        NUMBER,
  child_number               NUMBER,
  hash_value                 NUMBER,
  address                    RAW(8),
  plan_hash_value            NUMBER,
  optimizer_cost             NUMBER,
  buffer_gets                NUMBER,
  disk_reads                 NUMBER,
  cpu_time                   NUMBER,
  elapsed_time               NUMBER,
  sharable_mem               NUMBER,
  invalidations              NUMBER,
  loads                      NUMBER,
  sorts                      NUMBER,
  parsing_user_id            NUMBER,
  parse_calls                NUMBER,
  executions                 NUMBER,
  fetches                    NUMBER,
  rows_processed             NUMBER,
  module                     VARCHAR2(64),
  action                     VARCHAR2(64)
 )
NOLOGGING TABLESPACE &&p_tablespace;


CREATE TABLE sqla$sqltext
(
  snap_id                    NUMBER,
  top                        NUMBER,
  piece                      NUMBER,
  sql_text                   VARCHAR2(64)
 )
NOLOGGING TABLESPACE &&p_tablespace;


CREATE TABLE sqla$plan_table
(
  snap_id                    NUMBER,
  top                        NUMBER,
  statement_id               VARCHAR2(30),
  timestamp                  DATE,
  remarks                    VARCHAR2(80),
  operation                  VARCHAR2(30),
  options                    VARCHAR2(225),
  object_node                VARCHAR2(128),
  object_owner               VARCHAR2(30),
  object_name                VARCHAR2(30),
  object_instance            NUMERIC,
  object_type                VARCHAR2(30),
  optimizer                  VARCHAR2(255),
  search_columns             NUMBER,
  id                         NUMERIC,
  parent_id                  NUMERIC,
  position                   NUMERIC,
  cost                       NUMERIC,
  cardinality                NUMERIC,
  bytes                      NUMERIC,
  other_tag                  VARCHAR2(255),
  partition_start            VARCHAR2(255),
  partition_stop             VARCHAR2(255),
  partition_id               NUMERIC,
  other                      CLOB,
  distribution               VARCHAR2(30),
  depth                      NUMBER
 )
NOLOGGING TABLESPACE &&p_tablespace;


CREATE TABLE sqla$sql_plan
(
  snap_id                    NUMBER,
  top                        NUMBER,
  child_number               NUMBER,
  operation                  VARCHAR2(90),
  options                    VARCHAR2(90),
  object_node                VARCHAR2(30),
  object#                    NUMBER,
  object_owner               VARCHAR2(30),
  object_name                VARCHAR2(64),
  optimizer                  VARCHAR2(60),
  id                         NUMBER,
  parent_id                  NUMBER,
  depth                      NUMBER,
  position                   NUMBER,
  search_columns             NUMBER,
  cost                       NUMBER,
  cardinality                NUMBER,
  bytes                      NUMBER,
  other_tag                  VARCHAR2(105),
  partition_start            VARCHAR2(15),
  partition_stop             VARCHAR2(15),
  partition_id               NUMBER,
  other                      VARCHAR2(4000),
  distribution               VARCHAR2(60),
  cpu_cost                   NUMBER,
  io_cost                    NUMBER,
  temp_space                 NUMBER,
  access_predicates          VARCHAR2(4000),
  filter_predicates          VARCHAR2(4000)
 )
NOLOGGING TABLESPACE &&p_tablespace;


CREATE TABLE sqla$sql_plan_statistics
(
  snap_id                    NUMBER,
  top                        NUMBER,
  child_number               NUMBER,
  operation_id               NUMBER,
  executions                 NUMBER,
  last_starts                NUMBER,
  starts                     NUMBER,
  last_output_rows           NUMBER,
  output_rows                NUMBER,
  last_cr_buffer_gets        NUMBER,
  cr_buffer_gets             NUMBER,
  last_cu_buffer_gets        NUMBER,
  cu_buffer_gets             NUMBER,
  last_disk_reads            NUMBER,
  disk_reads                 NUMBER,
  last_disk_writes           NUMBER,
  disk_writes                NUMBER,
  last_elapsed_time          NUMBER,
  elapsed_time               NUMBER
 )
NOLOGGING TABLESPACE &&p_tablespace;


CREATE TABLE sqla$sql_workarea
(
  snap_id                    NUMBER,
  top                        NUMBER,
  child_number               NUMBER,
  operation_id               NUMBER,
  operation_type             VARCHAR2(20),
  policy                     VARCHAR2(10),
  estimated_optimal_size     NUMBER,
  estimated_onepass_size     NUMBER,
  last_memory_used           NUMBER,
  last_execution             VARCHAR2(10),
  last_degree                NUMBER,
  total_executions           NUMBER,
  optimal_executions         NUMBER,
  onepass_executions         NUMBER,
  multipasses_executions     NUMBER,
  active_time                NUMBER,
  max_tempseg_size           NUMBER,
  last_tempseg_size          NUMBER
 )
NOLOGGING TABLESPACE &&p_tablespace;


CREATE TABLE sqla$tables
(
  snap_id                    NUMBER,
  owner                      VARCHAR2(30),
  table_name                 VARCHAR2(30),
  num_rows                   NUMBER,
  blocks                     NUMBER,
  sample_size                NUMBER,
  last_analyzed              DATE
 )
NOLOGGING TABLESPACE &&p_tablespace;


CREATE TABLE sqla$indexes
(
  snap_id                    NUMBER,
  owner                      VARCHAR2(30),
  index_name                 VARCHAR2(30),
  table_owner                VARCHAR2(30),
  table_name                 VARCHAR2(30),
  uniqueness                 VARCHAR2(9),
  num_rows                   NUMBER,
  leaf_blocks                NUMBER,
  sample_size                NUMBER,
  last_analyzed              DATE,
  indexed_columns            VARCHAR2(600)
 )
NOLOGGING TABLESPACE &&p_tablespace;


CREATE TABLE sqla$session_process
(
  snap_id                    NUMBER,
  top                        NUMBER,
  sid                        NUMBER,
  audsid                     NUMBER,
  process                    VARCHAR2(12),
  logon_time                 DATE,
  pid                        NUMBER,
  spid                       VARCHAR2(12),
  apps_user_name             VARCHAR2(20),
  apps_module                VARCHAR2(60)
 )
NOLOGGING TABLESPACE &&p_tablespace;


CREATE TABLE sqla$range
(
  range_id                   NUMBER,
  sql_text                   VARCHAR2(1000),
  hash_value                 NUMBER,
  blocks                     NUMBER,
  top_range                  NUMBER,
  snap_id                    NUMBER,
  top_snap                   NUMBER
 )
NOLOGGING TABLESPACE &&p_tablespace;


/* *************************************************************************** */

PRO Creating SQLA$ Indexes

CREATE INDEX sqla$plan_table_n1
          ON sqla$plan_table
             ( snap_id,
               top
              )
NOLOGGING TABLESPACE &&p_tablespace;


CREATE INDEX sqla$plan_table_n2
          ON sqla$plan_table
             ( statement_id,
               parent_id
              )
NOLOGGING TABLESPACE &&p_tablespace;


CREATE INDEX sqla$sql_plan_n1
          ON sqla$sql_plan
             ( snap_id,
               top,
               child_number
              )
NOLOGGING TABLESPACE &&p_tablespace;


/* *************************************************************************** */

PRO Creating SQLA$ Views

CREATE OR REPLACE VIEW sqla$active_form AS
SELECT /* INVALID for non-APPS databases */
       rf.audsid,
       fl.pid,
       fl.process_spid spid,
       ( SELECT SUBSTR(fu.user_name, 1, 20)
           FROM fnd_user fu
          WHERE fu.user_id = fl.user_id ) apps_user_name,
       ( SELECT SUBSTR('FORM '||ff.form_name||' ('||ff.user_form_name||')', 1, 60)
           FROM fnd_form_vl ff
          WHERE ff.application_id = rf.form_appl_id
            AND ff.form_id        = rf.form_id ) apps_form_name
  FROM fnd_logins           fl,
       fnd_login_resp_forms rf
 WHERE fl.login_type = 'FORM'
   AND fl.start_time > SYSDATE - 7 /* login within last 7 days */
   AND fl.end_time  IS NULL
   AND fl.login_id   = rf.login_id
   AND rf.end_time  IS NULL;


CREATE OR REPLACE VIEW sqla$active_conc_request AS
SELECT /* INVALID for non-APPS databases */
       v.oracle_process_id spid,
       v.oracle_session_id audsid,
       v.requestor apps_user_name,
       'CONC REQ '||v.request_id||' '||v.program apps_program
  FROM fnd_conc_requests_form_v v
 WHERE v.phase_code  = 'R'
   AND v.status_code = 'R'
   AND v.requested_start_date < SYSDATE;
