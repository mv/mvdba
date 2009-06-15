SET DEF '~';
CREATE OR REPLACE PACKAGE BODY sqla$ AS
/* $Header: sqlapkgb.sql 238684.1 2003/12/01 12:00:00 pkm ship $ */

/*******************************************************************************/

PROCEDURE truncate_repo IS
BEGIN /* truncate_repo */
   EXECUTE IMMEDIATE 'TRUNCATE TABLE sqla$snap';
   EXECUTE IMMEDIATE 'TRUNCATE TABLE sqla$sqlarea';
   EXECUTE IMMEDIATE 'TRUNCATE TABLE sqla$sql';
   EXECUTE IMMEDIATE 'TRUNCATE TABLE sqla$sqltext';
   EXECUTE IMMEDIATE 'TRUNCATE TABLE sqla$plan_table';
   EXECUTE IMMEDIATE 'TRUNCATE TABLE sqla$sql_plan';
   EXECUTE IMMEDIATE 'TRUNCATE TABLE sqla$sql_plan_statistics';
   EXECUTE IMMEDIATE 'TRUNCATE TABLE sqla$sql_workarea';
   EXECUTE IMMEDIATE 'TRUNCATE TABLE sqla$tables';
   EXECUTE IMMEDIATE 'TRUNCATE TABLE sqla$indexes';
   EXECUTE IMMEDIATE 'TRUNCATE TABLE sqla$session_process';
   EXECUTE IMMEDIATE 'TRUNCATE TABLE sqla$range';
END truncate_repo;

/*******************************************************************************/

PROCEDURE purge_repo
( p_days_to_keep    IN  NUMBER
 ) IS
   l_count  NUMBER;
BEGIN /* purge_repo */
   DELETE sqla$snap WHERE creation_date < SYSDATE - p_days_to_keep;

   SELECT COUNT(*) INTO l_count FROM sqla$snap;

   IF l_count = 0 THEN
      TRUNCATE_REPO;
      RETURN;
   END IF;

   DELETE sqla$sqlarea
    WHERE snap_id NOT IN ( SELECT snap_id FROM sqla$snap );

   DELETE sqla$sql
    WHERE snap_id NOT IN ( SELECT snap_id FROM sqla$snap );

   DELETE sqla$sqltext
    WHERE snap_id NOT IN ( SELECT snap_id FROM sqla$snap );

   DELETE sqla$plan_table
    WHERE snap_id NOT IN ( SELECT snap_id FROM sqla$snap );

   DELETE sqla$sql_plan
    WHERE snap_id NOT IN ( SELECT snap_id FROM sqla$snap );

   DELETE sqla$sql_plan_statistics
    WHERE snap_id NOT IN ( SELECT snap_id FROM sqla$snap );

   DELETE sqla$sql_workarea
    WHERE snap_id NOT IN ( SELECT snap_id FROM sqla$snap );

   DELETE sqla$tables
    WHERE snap_id NOT IN ( SELECT snap_id FROM sqla$snap );

   DELETE sqla$indexes
    WHERE snap_id NOT IN ( SELECT snap_id FROM sqla$snap );

   DELETE sqla$session_process
    WHERE snap_id NOT IN ( SELECT snap_id FROM sqla$snap );

   DELETE sqla$range
    WHERE snap_id NOT IN ( SELECT snap_id FROM sqla$snap );

   COMMIT;
END purge_repo;

/*******************************************************************************/

PROCEDURE env
( x_platform        OUT VARCHAR2,
  x_database        OUT VARCHAR2,
  x_instance        OUT VARCHAR2,
  x_startup_time    OUT VARCHAR2,
  x_rdbms_release   OUT VARCHAR2,
  x_cpu_count       OUT VARCHAR2
 ) IS
BEGIN /* env */
   SELECT SUBSTR(REPLACE(REPLACE(pcv1.product,'TNS for '),':')||pcv2.status,1,40)
     INTO x_platform
     FROM product_component_version pcv1,
          product_component_version pcv2
    WHERE UPPER(pcv1.product) LIKE '%TNS%'
      AND UPPER(pcv2.product) LIKE '%ORACLE%'
      AND ROWNUM = 1;

   SELECT SUBSTR(UPPER(name)||'('||TO_CHAR(dbid)||')',1,40)
     INTO x_database
     FROM v$database;

   SELECT SUBSTR(UPPER(instance_name)||'('||TO_CHAR(instance_number)||')',1,40),
          SUBSTR(version,1,17),
          TO_CHAR(startup_time,'DD-MON-YYYY HH24:MI')
     INTO x_instance, x_rdbms_release, x_startup_time
     FROM v$instance;

   SELECT SUBSTR(value,1,10)
     INTO x_cpu_count
     FROM v$parameter
    WHERE name = 'cpu_count';
END env;

/*******************************************************************************/

PROCEDURE collect
( p_snap_id         IN  NUMBER
 ) IS
   l_rdbms_release  VARCHAR2(30);
   l_sql            VARCHAR2(32767);
   l_count          NUMBER;

BEGIN /* collect */
   SELECT SUBSTR(version,1,17)
     INTO l_rdbms_release
     FROM v$instance;

   IF SUBSTR(l_rdbms_release,1,1) = '8' THEN
      NULL;
   ELSIF SUBSTR(l_rdbms_release,1,3) = '9.0' THEN
      l_sql :=
      'INSERT INTO sqla$sql '||
      'SELECT sa.snap_id, '||
             'sa.top, '||
             's.child_number, '||
             's.hash_value, '||
             's.address, '||
             's.plan_hash_value, '||
             's.optimizer_cost, '||
             's.buffer_gets, '||
             's.disk_reads, '||
             's.cpu_time, '||
             's.elapsed_time, '||
             's.sharable_mem, '||
             's.invalidations, '||
             's.loads, '||
             's.sorts, '||
             's.parsing_user_id, '||
             's.parse_calls, '||
             's.executions, '||
             'NULL fetches, '||
             's.rows_processed, '||
             's.module, '||
             's.action '||
        'FROM sqla$sqlarea sa, '||
             'v$sql        s '||
       'WHERE sa.snap_id    = '||TO_CHAR(p_snap_id)||' '||
         'AND sa.hash_value = s.hash_value '||
         'AND sa.address    = s.address ';
      EXECUTE IMMEDIATE l_sql;

      l_sql :=
      'INSERT INTO sqla$sql_plan '||
      'SELECT s.snap_id, '||
             's.top, '||
             's.child_number, '||
             'sp.operation, '||
             'sp.options, '||
             'sp.object_node, '||
             'sp.object#, '||
             'sp.object_owner, '||
             'sp.object_name, '||
             'sp.optimizer, '||
             'sp.id, '||
             'sp.parent_id, '||
             'sp.depth, '||
             'sp.position, '||
             'NULL search_columns, '||
             'sp.cost, '||
             'sp.cardinality, '||
             'sp.bytes, '||
             'sp.other_tag, '||
             'sp.partition_start, '||
             'sp.partition_stop, '||
             'sp.partition_id, '||
             'sp.other, '||
             'sp.distribution, '||
             'sp.cpu_cost, '||
             'sp.io_cost, '||
             'sp.temp_space, '||
             'NULL, /* should be sp.access_predicates, 2254299 */ '||
             'NULL /* should be sp.filter_predicates, 2254299 */ '||
        'FROM sqla$sql   s, '||
             'v$sql_plan sp '||
       'WHERE s.snap_id      = '||TO_CHAR(p_snap_id)||' '||
         'AND s.address      = sp.address '||
         'AND s.hash_value   = sp.hash_value '||
         'AND s.child_number = sp.child_number ';
      EXECUTE IMMEDIATE l_sql;

      l_sql :=
      'INSERT INTO sqla$sql_workarea '||
      'SELECT s.snap_id, '||
             's.top, '||
             's.child_number, '||
             'swa.operation_id, '||
             'swa.operation_type, '||
             'swa.policy, '||
             'swa.estimated_optimal_size, '||
             'swa.estimated_onepass_size, '||
             'swa.last_memory_used, '||
             'swa.last_execution, '||
             'swa.last_degree, '||
             'swa.total_executions, '||
             'swa.optimal_executions, '||
             'swa.onepass_executions, '||
             'swa.multipasses_executions, '||
             'swa.active_time, '||
             'NULL max_tempseg_size, '||
             'NULL last_tempseg_size '||
        'FROM sqla$sql s, '||
             'v$sql_workarea swa '||
       'WHERE s.snap_id      = '||TO_CHAR(p_snap_id)||' '||
         'AND s.address      = swa.address '||
         'AND s.hash_value   = swa.hash_value '||
         'AND s.child_number = swa.child_number ';
      EXECUTE IMMEDIATE l_sql;
   ELSE
      l_sql :=
      'INSERT INTO sqla$sql '||
      'SELECT sa.snap_id, '||
             'sa.top, '||
             's.child_number, '||
             's.hash_value, '||
             's.address, '||
             's.plan_hash_value, '||
             's.optimizer_cost, '||
             's.buffer_gets, '||
             's.disk_reads, '||
             's.cpu_time, '||
             's.elapsed_time, '||
             's.sharable_mem, '||
             's.invalidations, '||
             's.loads, '||
             's.sorts, '||
             's.parsing_user_id, '||
             's.parse_calls, '||
             's.executions, '||
             's.fetches, '||
             's.rows_processed, '||
             's.module, '||
             's.action '||
        'FROM sqla$sqlarea sa, '||
             'v$sql        s '||
       'WHERE sa.snap_id    = '||TO_CHAR(p_snap_id)||' '||
         'AND sa.hash_value = s.hash_value '||
         'AND sa.address    = s.address ';
      EXECUTE IMMEDIATE l_sql;

      l_sql :=
      'INSERT INTO sqla$sql_plan '||
      'SELECT s.snap_id, '||
             's.top, '||
             's.child_number, '||
             'sp.operation, '||
             'sp.options, '||
             'sp.object_node, '||
             'sp.object#, '||
             'sp.object_owner, '||
             'sp.object_name, '||
             'sp.optimizer, '||
             'sp.id, '||
             'sp.parent_id, '||
             'sp.depth, '||
             'sp.position, '||
             'sp.search_columns, '||
             'sp.cost, '||
             'sp.cardinality, '||
             'sp.bytes, '||
             'sp.other_tag, '||
             'sp.partition_start, '||
             'sp.partition_stop, '||
             'sp.partition_id, '||
             'sp.other, '||
             'sp.distribution, '||
             'sp.cpu_cost, '||
             'sp.io_cost, '||
             'sp.temp_space, '||
             'NULL, /* should be sp.access_predicates, 2254299 */ '||
             'NULL /* should be sp.filter_predicates, 2254299 */ '||
        'FROM sqla$sql   s, '||
             'v$sql_plan sp '||
       'WHERE s.snap_id      = '||TO_CHAR(p_snap_id)||' '||
         'AND s.address      = sp.address '||
         'AND s.hash_value   = sp.hash_value '||
         'AND s.child_number = sp.child_number ';
      EXECUTE IMMEDIATE l_sql;

      l_sql :=
      'INSERT INTO sqla$sql_plan_statistics '||
      'SELECT s.snap_id, '||
             's.top, '||
             's.child_number, '||
             'sps.operation_id, '||
             'sps.executions, '||
             'sps.last_starts, '||
             'sps.starts, '||
             'sps.last_output_rows, '||
             'sps.output_rows, '||
             'sps.last_cr_buffer_gets, '||
             'sps.cr_buffer_gets, '||
             'sps.last_cu_buffer_gets, '||
             'sps.cu_buffer_gets, '||
             'sps.last_disk_reads, '||
             'sps.disk_reads, '||
             'sps.last_disk_writes, '||
             'sps.disk_writes, '||
             'sps.last_elapsed_time, '||
             'sps.elapsed_time '||
        'FROM sqla$sql s, '||
             'v$sql_plan_statistics sps '||
       'WHERE s.snap_id      = '||TO_CHAR(p_snap_id)||' '||
         'AND s.address      = sps.address '||
         'AND s.hash_value   = sps.hash_value '||
         'AND s.child_number = sps.child_number ';
      EXECUTE IMMEDIATE l_sql;

      l_sql :=
      'INSERT INTO sqla$sql_workarea '||
      'SELECT s.snap_id, '||
             's.top, '||
             's.child_number, '||
             'swa.operation_id, '||
             'swa.operation_type, '||
             'swa.policy, '||
             'swa.estimated_optimal_size, '||
             'swa.estimated_onepass_size, '||
             'swa.last_memory_used, '||
             'swa.last_execution, '||
             'swa.last_degree, '||
             'swa.total_executions, '||
             'swa.optimal_executions, '||
             'swa.onepass_executions, '||
             'swa.multipasses_executions, '||
             'swa.active_time, '||
             'swa.max_tempseg_size, '||
             'swa.last_tempseg_size '||
        'FROM sqla$sql s, '||
             'v$sql_workarea swa '||
       'WHERE s.snap_id      = '||TO_CHAR(p_snap_id)||' '||
         'AND s.address      = swa.address '||
         'AND s.hash_value   = swa.hash_value '||
         'AND s.child_number = swa.child_number ';
      EXECUTE IMMEDIATE l_sql;
   END IF;

   INSERT INTO sqla$sqltext
   SELECT sa.snap_id,
          sa.top,
          st.piece,
          st.sql_text
     FROM sqla$sqlarea sa,
          v$sqltext    st
    WHERE sa.snap_id    = p_snap_id
      AND sa.hash_value = st.hash_value
      AND sa.address    = st.address;

   INSERT INTO sqla$session_process
   SELECT p_snap_id,
          sa.top,
          s.sid,
          s.audsid,
          SUBSTR(s.process,1,12),
          s.logon_time,
          p.pid,
          SUBSTR(p.spid,1,12),
          NULL apps_user_name,
          NULL apps_module
     FROM ( SELECT sa.top, oc.saddr, oc.sid
              FROM sqla$sqlarea  sa,
                   v$open_cursor oc
             WHERE sa.snap_id    = p_snap_id
               AND sa.hash_value = oc.hash_value
               AND sa.address    = oc.address
             UNION
            SELECT sa.top, s.saddr, s.sid
              FROM sqla$sqlarea sa,
                   v$session    s
             WHERE sa.snap_id    = p_snap_id
               AND sa.hash_value = s.sql_hash_value
               AND sa.address    = s.sql_address
             UNION
            SELECT sa.top, s.saddr, s.sid
              FROM sqla$sqlarea sa,
                   v$session    s
             WHERE sa.snap_id    = p_snap_id
               AND sa.hash_value = s.prev_hash_value
               AND sa.address    = s.prev_sql_addr ) sa,
          v$session s,
          v$process p
    WHERE sa.saddr = s.saddr
      AND sa.sid   = s.sid
      AND s.paddr  = p.addr;

   SELECT COUNT(*)
     INTO l_count
     FROM user_objects
    WHERE object_name = 'SQLA$ACTIVE_FORM'
      AND object_type = 'VIEW'
      AND status      = 'VALID';

   IF l_count = 1 THEN
      l_sql :=
      'UPDATE sqla$session_process sp '||
         'SET ( sp.apps_user_name, sp.apps_module ) = '||
             '( SELECT /*+ LEADING(af.rf) INDEX(af.rf fnd_login_resp_forms_n2) */ '||
                      'af.apps_user_name, af.apps_form_name '||
                 'FROM sqla$active_form af '||
                'WHERE af.pid    = sp.pid '||
                  'AND af.spid   = sp.spid '||
                  'AND af.audsid = sp.audsid '||
                  'AND ROWNUM    = 1 ) '||
       'WHERE sp.snap_id = '||TO_CHAR(p_snap_id);
      EXECUTE IMMEDIATE l_sql;
   END IF;

   SELECT COUNT(*)
     INTO l_count
     FROM user_objects
    WHERE object_name = 'SQLA$ACTIVE_CONC_REQUEST'
      AND object_type = 'VIEW'
      AND status      = 'VALID';

   IF l_count = 1 THEN
      l_sql :=
      'UPDATE sqla$session_process sp '||
         'SET ( sp.apps_user_name, sp.apps_module ) = '||
             '( SELECT /*+ LEADING(acr.v.r) INDEX(acr.v.r fnd_concurrent_requests_n7) */ '||
                      'acr.apps_user_name, acr.apps_program '||
                 'FROM sqla$active_conc_request acr '||
                'WHERE acr.spid   = sp.spid '||
                  'AND acr.audsid = sp.audsid '||
                  'AND ROWNUM     = 1 ) '||
       'WHERE sp.apps_user_name IS NULL '||
         'AND sp.snap_id = '||TO_CHAR(p_snap_id);
      EXECUTE IMMEDIATE l_sql;
   END IF;

   UPDATE sqla$sqlarea
      SET cpu_time = NULL
    WHERE snap_id = p_snap_id
      AND cpu_time > 30*24*60*60*1000000 /* 30 days */;

   UPDATE sqla$sqlarea
      SET elapsed_time = NULL
    WHERE snap_id = p_snap_id
      AND elapsed_time > 30*24*60*60*1000000 /* 30 days */;

   UPDATE sqla$sql
      SET cpu_time = NULL
    WHERE snap_id = p_snap_id
      AND cpu_time > 30*24*60*60*1000000 /* 30 days */;

   UPDATE sqla$sql
      SET elapsed_time = NULL
    WHERE snap_id = p_snap_id
      AND elapsed_time > 30*24*60*60*1000000 /* 30 days */;

   COMMIT;
END collect;

/*******************************************************************************/

PROCEDURE explain_plan
( p_snap_id         IN  NUMBER
 ) IS
   l_rdbms_release   VARCHAR2(30);
   l_sql_text        VARCHAR2(32767);
   l_sql_text_temp   VARCHAR2(32767);
   l_statement_id    VARCHAR2(30);
   l_sqlerrm         VARCHAR2(512);

   CURSOR c1_sql IS
      SELECT top
        FROM sqla$sqlarea
       WHERE snap_id = p_snap_id;

   CURSOR c2_sql_text( c_top NUMBER ) IS
       SELECT sql_text
         FROM sqla$sqltext
        WHERE snap_id = p_snap_id
          AND top     = c_top
        ORDER BY
              piece;

   CURSOR c3_level IS
      SELECT ROWID row_id,
             LEVEL depth
        FROM sqla$plan_table
       START WITH
             statement_id = l_statement_id
         AND id           = 0
     CONNECT BY
             PRIOR statement_id = statement_id
         AND PRIOR id           = parent_id;

/*******************************************************************************/

BEGIN /* explain_plan */
   SELECT SUBSTR(version,1,17)
     INTO l_rdbms_release
     FROM v$instance;

   IF SUBSTR(l_rdbms_release,1,1) <> '8' THEN
      RETURN;
   END IF;

   FOR c1 IN c1_sql LOOP
      l_statement_id := TO_CHAR(p_snap_id)||'-'||TO_CHAR(c1.top);
      l_sql_text := 'EXPLAIN PLAN SET statement_id='''||l_statement_id||''' INTO sqla$plan_table FOR ';

      FOR c2 IN c2_sql_text(c1.top) LOOP
         l_sql_text_temp := c2.sql_text;
         IF l_sql_text_temp LIKE '%--+%' THEN
            NULL;
         ELSIF l_sql_text_temp LIKE '%--%' THEN
            l_sql_text_temp := SUBSTR(l_sql_text_temp, 1, INSTR(l_sql_text_temp, '--') -1);
         END IF;
         l_sql_text := l_sql_text||l_sql_text_temp;
      END LOOP;

      DELETE sqla$plan_table WHERE statement_id = l_statement_id;

      BEGIN
         l_sqlerrm := NULL;
         EXECUTE IMMEDIATE l_sql_text;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_sqlerrm := SUBSTR(SQLERRM, 1, 512);
            UPDATE sqla$sqlarea
               SET explain_plan_error = l_sqlerrm
             WHERE snap_id = p_snap_id
               AND top     = c1.top;
      END;

      IF l_sqlerrm IS NULL THEN
         FOR c3 IN c3_level LOOP
            UPDATE sqla$plan_table
               SET snap_id = p_snap_id,
                   top     = c1.top,
                   depth   = c3.depth
             WHERE ROWID   = c3.row_id;
         END LOOP;
      END IF;
   END LOOP;

   COMMIT;
END explain_plan;

/*******************************************************************************/

PROCEDURE sql_plan
( p_snap_id         IN  NUMBER
 ) IS
   l_rdbms_release   VARCHAR2(30);

   CURSOR c1_sql IS
      SELECT top, child_number
        FROM sqla$sql
       WHERE snap_id = p_snap_id
         AND plan_hash_value <> 0;

/*******************************************************************************/

BEGIN /* sql_plan */
   SELECT SUBSTR(version,1,17)
     INTO l_rdbms_release
     FROM v$instance;

   IF SUBSTR(l_rdbms_release,1,1) = '8' THEN
      RETURN;
   END IF;

   COMMIT;
END sql_plan;

/*******************************************************************************/

PROCEDURE tables_indexes
( p_snap_id         IN  NUMBER
 ) IS
   l_indexed_columns VARCHAR2(600);

   CURSOR c1_indexes IS
      SELECT ROWID row_id, owner, index_name
        FROM sqla$indexes
       WHERE snap_id = p_snap_id
       ORDER BY
             ROWID;

   CURSOR c2_ind_columns (c_index_owner VARCHAR2, c_index_name VARCHAR2) IS
      SELECT column_name||' ' column_name
        FROM dba_ind_columns
       WHERE index_owner = c_index_owner
         AND index_name  = c_index_name
       ORDER BY
             column_position;

BEGIN /* tables_indexes */
   INSERT INTO sqla$tables
   ( snap_id     ,
     owner        ,
     table_name   ,
     num_rows     ,
     blocks       ,
     sample_size  ,
     last_analyzed
    )
   SELECT p_snap_id                       ,
          owner                            ,
          table_name                       ,
          ROUND(num_rows) num_rows       ,
          blocks                           ,
          ROUND(sample_size) sample_size ,
          last_analyzed
     FROM dba_tables
    WHERE ( owner, table_name ) IN
          ( SELECT object_owner owner, object_name table_name
              FROM sqla$plan_table
             WHERE snap_id = p_snap_id
               AND operation = 'TABLE ACCESS'
             UNION
            SELECT object_owner owner, object_name table_name
              FROM sqla$sql_plan
             WHERE snap_id = p_snap_id
               AND operation = 'TABLE ACCESS'
             UNION
            SELECT table_owner owner, table_name
              FROM dba_indexes
             WHERE ( owner, index_name ) IN
                   ( SELECT object_owner owner, object_name index_name
                       FROM sqla$plan_table
                      WHERE snap_id = p_snap_id
                        AND operation LIKE '%INDEX%'
                      UNION
                     SELECT object_owner owner, object_name index_name
                       FROM sqla$sql_plan
                      WHERE snap_id = p_snap_id
                        AND operation LIKE '%INDEX%'
                    )
           );

   INSERT INTO sqla$indexes
   ( snap_id     ,
     owner        ,
     index_name   ,
     table_owner  ,
     table_name   ,
     uniqueness   ,
     num_rows     ,
     leaf_blocks  ,
     sample_size  ,
     last_analyzed
    )
   SELECT p_snap_id ,
          owner      ,
          index_name ,
          table_owner,
          table_name ,
          uniqueness ,
          ROUND(num_rows) num_rows ,
          ROUND(leaf_blocks) leaf_blocks ,
          ROUND(sample_size) sample_size ,
          last_analyzed
     FROM dba_indexes
    WHERE ( table_owner, table_name ) IN
          ( SELECT owner, table_name
              FROM sqla$tables
             WHERE snap_id = p_snap_id
           );

   FOR c1 IN c1_indexes LOOP
       l_indexed_columns := NULL;
       FOR c2 IN c2_ind_columns(c1.owner, c1.index_name) LOOP
           l_indexed_columns := l_indexed_columns||c2.column_name;
       END LOOP;
       l_indexed_columns := TRIM(l_indexed_columns);
       UPDATE sqla$indexes SET indexed_columns = l_indexed_columns WHERE ROWID = c1.row_id;
   END LOOP;

   COMMIT;
END tables_indexes;

/*******************************************************************************/

PROCEDURE snapshot_top
( p_snap_id         IN  NUMBER,
  p_top             IN  NUMBER
 ) IS
   l_rdbms_release   VARCHAR2(30);
   l_sql             VARCHAR2(32767);

BEGIN /* snapshot_top */
   SELECT SUBSTR(version,1,17)
     INTO l_rdbms_release
     FROM v$instance;

   IF SUBSTR(l_rdbms_release,1,1) = '8' THEN
      l_sql :=
      'INSERT INTO sqla$sqlarea '||
      'SELECT '||TO_CHAR(p_snap_id)||' snap_id, '||
             'top.top, '||
             'sa.sql_text, '||
             'top.hash_value, '||
             'top.address, '||
             'ABS(sa.buffer_gets), '||
             'ABS(sa.disk_reads), '||
             'NULL cpu_time, '||
             'NULL elapsed_time, '||
             'sa.sharable_mem, '||
             'sa.invalidations, '||
             'sa.loads, '||
             'sa.version_count, '||
             'sa.sorts, '||
             'sa.parsing_user_id, '||
             'sa.parse_calls, '||
             'sa.executions, '||
             'NULL fetches, '||
             'sa.rows_processed, '||
             'sa.command_type, '||
             'sa.module, '||
             'sa.action, '||
             'NULL explain_plan_error '||
        'FROM v$sqlarea sa, '||
             '( SELECT ROWNUM top, hash_value, address '||
                'FROM ( SELECT /*+ NO_MERGE */ '||
                              'COUNT(*) row_count, AVG(position) position, '||
                              'hash_value, address  '||
                          'FROM ( SELECT ROWNUM position, hash_value, address '||
                                   'FROM ( SELECT /*+ NO_MERGE */ hash_value, address '||
                                            'FROM v$sqlarea '||
                                           'WHERE command_type IN (2, 3, 6, 7) '||
                                             'AND ABS(buffer_gets) > 10000 '||
                                           'ORDER BY ABS(buffer_gets) DESC ) '||
                                  'WHERE ROWNUM < '||TO_CHAR(p_top)||'+1 '||
                                  'UNION ALL '||
                                 'SELECT ROWNUM position, hash_value, address '||
                                   'FROM ( SELECT /*+ NO_MERGE */ hash_value, address '||
                                            'FROM v$sqlarea '||
                                           'WHERE command_type IN (2, 3, 6, 7) '||
                                             'AND ABS(disk_reads) > 1000 '||
                                           'ORDER BY ABS(disk_reads) DESC ) '||
                                  'WHERE ROWNUM < '||TO_CHAR(p_top)||'+1 ) '||
                         'GROUP BY hash_value, address '||
                         'ORDER BY 1 DESC, 2 ASC ) '||
                'WHERE ROWNUM < '||TO_CHAR(p_top)||'+1 ) top '||
       'WHERE top.hash_value = sa.hash_value '||
         'AND top.address    = sa.address ';
      EXECUTE IMMEDIATE l_sql;
   ELSIF SUBSTR(l_rdbms_release,1,3) = '9.0' THEN
      l_sql :=
         'INSERT INTO sqla$sqlarea '||
         'SELECT '||TO_CHAR(p_snap_id)||' snap_id, '||
             'top.top, '||
             'sa.sql_text, '||
             'top.hash_value, '||
             'top.address, '||
             'ABS(sa.buffer_gets), '||
             'ABS(sa.disk_reads), '||
             'sa.cpu_time, '||
             'sa.elapsed_time, '||
             'sa.sharable_mem, '||
             'sa.invalidations, '||
             'sa.loads, '||
             'sa.version_count, '||
             'sa.sorts, '||
             'sa.parsing_user_id, '||
             'sa.parse_calls, '||
             'sa.executions, '||
             'NULL fetches, '||
             'sa.rows_processed, '||
             'sa.command_type, '||
             'sa.module, '||
             'sa.action, '||
             'NULL explain_plan_error '||
        'FROM v$sqlarea sa, '||
             '( SELECT ROWNUM top, hash_value, address '||
                'FROM ( SELECT /*+ NO_MERGE */ '||
                              'COUNT(*) row_count, AVG(position) position, '||
                              'hash_value, address  '||
                          'FROM ( SELECT ROWNUM position, hash_value, address '||
                                   'FROM ( SELECT /*+ NO_MERGE */ hash_value, address '||
                                            'FROM v$sqlarea '||
                                           'WHERE is_obsolete = ''N'' '||
                                             'AND command_type IN (2, 3, 6, 7) '||
                                             'AND ABS(buffer_gets) > 10000 '||
                                           'ORDER BY ABS(buffer_gets) DESC ) '||
                                  'WHERE ROWNUM < '||TO_CHAR(p_top)||'+1 '||
                                  'UNION ALL '||
                                 'SELECT ROWNUM position, hash_value, address '||
                                   'FROM ( SELECT /*+ NO_MERGE */ hash_value, address '||
                                            'FROM v$sqlarea '||
                                           'WHERE is_obsolete = ''N'' '||
                                             'AND command_type IN (2, 3, 6, 7) '||
                                             'AND ABS(disk_reads) > 1000 '||
                                           'ORDER BY ABS(disk_reads) DESC ) '||
                                  'WHERE ROWNUM < '||TO_CHAR(p_top)||'+1 ) '||
                         'GROUP BY hash_value, address '||
                         'ORDER BY 1 DESC, 2 ASC ) '||
                'WHERE ROWNUM < '||TO_CHAR(p_top)||'+1 ) top '||
       'WHERE top.hash_value = sa.hash_value '||
         'AND top.address    = sa.address ';
      EXECUTE IMMEDIATE l_sql;
   ELSE
      l_sql :=
      'INSERT INTO sqla$sqlarea '||
      'SELECT '||TO_CHAR(p_snap_id)||' snap_id, '||
             'top.top, '||
             'sa.sql_text, '||
             'top.hash_value, '||
             'top.address, '||
             'ABS(sa.buffer_gets), '||
             'ABS(sa.disk_reads), '||
             'sa.cpu_time, '||
             'sa.elapsed_time, '||
             'sa.sharable_mem, '||
             'sa.invalidations, '||
             'sa.loads, '||
             'sa.version_count, '||
             'sa.sorts, '||
             'sa.parsing_user_id, '||
             'sa.parse_calls, '||
             'sa.executions, '||
             'sa.fetches, '||
             'sa.rows_processed, '||
             'sa.command_type, '||
             'sa.module, '||
             'sa.action, '||
             'NULL explain_plan_error '||
        'FROM v$sqlarea sa, '||
             '( SELECT ROWNUM top, hash_value, address '||
                'FROM ( SELECT /*+ NO_MERGE */ '||
                              'COUNT(*) row_count, AVG(position) position, '||
                              'hash_value, address  '||
                          'FROM ( SELECT ROWNUM position, hash_value, address '||
                                   'FROM ( SELECT /*+ NO_MERGE */ hash_value, address '||
                                            'FROM v$sqlarea '||
                                           'WHERE is_obsolete = ''N'' '||
                                             'AND command_type IN (2, 3, 6, 7) '||
                                             'AND ABS(buffer_gets) > 10000 '||
                                           'ORDER BY ABS(buffer_gets) DESC ) '||
                                  'WHERE ROWNUM < '||TO_CHAR(p_top)||'+1 '||
                                  'UNION ALL '||
                                 'SELECT ROWNUM position, hash_value, address '||
                                   'FROM ( SELECT /*+ NO_MERGE */ hash_value, address '||
                                            'FROM v$sqlarea '||
                                           'WHERE is_obsolete = ''N'' '||
                                             'AND command_type IN (2, 3, 6, 7) '||
                                             'AND ABS(disk_reads) > 1000 '||
                                           'ORDER BY ABS(disk_reads) DESC ) '||
                                  'WHERE ROWNUM < '||TO_CHAR(p_top)||'+1 ) '||
                         'GROUP BY hash_value, address '||
                         'ORDER BY 1 DESC, 2 ASC ) '||
                'WHERE ROWNUM < '||TO_CHAR(p_top)||'+1 ) top '||
       'WHERE top.hash_value = sa.hash_value '||
         'AND top.address    = sa.address ';
      EXECUTE IMMEDIATE l_sql;
   END IF;

   COMMIT;
   SQLA$.COLLECT(p_snap_id);
   SQLA$.EXPLAIN_PLAN(p_snap_id);
   SQLA$.SQL_PLAN(p_snap_id);
   SQLA$.TABLES_INDEXES(p_snap_id);
END snapshot_top;

/*******************************************************************************/

PROCEDURE snapshot
( p_top             IN  NUMBER DEFAULT 10
 ) IS
   l_snap_id NUMBER;
BEGIN /* snapshot */
   SELECT sqla$snap_seq.NEXTVAL INTO l_snap_id FROM DUAL;
   INSERT INTO sqla$snap VALUES (l_snap_id, SYSDATE);
   SQLA$.SNAPSHOT_TOP(l_snap_id, p_top);
END snapshot;

/*******************************************************************************/

PROCEDURE range
( p_range_id        IN  NUMBER,
  p_snap_id_from    IN  NUMBER,
  p_snap_id_to      IN  NUMBER,
  p_process_type    IN  VARCHAR2,
  p_top             IN  NUMBER
 ) IS
   l_rowcount NUMBER;
   CURSOR c1_unique_sql IS
      SELECT ROWID row_id
        FROM sqla$range
       WHERE range_id = p_range_id
       ORDER BY
             blocks DESC;

BEGIN /* range */
   INSERT INTO sqla$range
   SELECT p_range_id, sql_text, hash_value,
          MAX(DECODE(p_process_type,'LR',buffer_gets,'PR',disk_reads,0)) blocks,
          NULL, NULL, NULL
     FROM sqla$sqlarea
    WHERE snap_id BETWEEN p_snap_id_from AND p_snap_id_to
    GROUP BY
          sql_text, hash_value;

   FOR c1 IN c1_unique_sql LOOP
      l_rowcount := c1_unique_sql%ROWCOUNT;
      IF l_rowcount <= p_top THEN
         UPDATE sqla$range
            SET top_range = l_rowcount
          WHERE ROWID = c1.row_id;
      ELSE
         DELETE sqla$range
          WHERE ROWID = c1.row_id;
      END IF;
   END LOOP;

   UPDATE sqla$range r
      SET ( r.snap_id, r.top_snap ) =
          ( SELECT a.snap_id, a.top
              FROM sqla$sqlarea a
             WHERE a.sql_text   = r.sql_text
               AND a.hash_value = r.hash_value
               AND DECODE(p_process_type,'LR',a.buffer_gets,'PR',a.disk_reads,0) = r.blocks
               AND a.snap_id BETWEEN p_snap_id_from AND p_snap_id_to
               AND ROWNUM       = 1 )
    WHERE r.range_id = p_range_id;

   COMMIT;
END range;

/*******************************************************************************/

PROCEDURE put_line
( p_line            IN  VARCHAR2
 ) IS
BEGIN /* put_line */
   DBMS_OUTPUT.PUT_LINE(SUBSTR(p_line, 1, 255));
END put_line;

/*******************************************************************************/

PROCEDURE put_just_stars
IS
BEGIN /* put_just_stars */
   -- PUT_LINE(RPAD('*', 130, '*'));
   PUT_LINE('<hr>');
END put_just_stars;

/*******************************************************************************/

PROCEDURE put_stars
IS
BEGIN /* put_stars */
   PUT_LINE(CHR(0));
   PUT_JUST_STARS;
   PUT_LINE(CHR(0));
END put_stars;

/*******************************************************************************/

PROCEDURE put_cursor
( p_top_range       IN  NUMBER,
  p_snap_id         IN  NUMBER,
  p_top_snap        IN  NUMBER
 ) IS
   l_top_range      VARCHAR2(100) := NULL;
   l_text           VARCHAR2(4000);

   CURSOR c1_sqlarea IS
      SELECT buffer_gets,
             disk_reads,
             hash_value,
             address,
             explain_plan_error
        FROM sqla$sqlarea
       WHERE snap_id = p_snap_id
         AND top     = p_top_snap;

   CURSOR c2_sqltext IS
      SELECT sql_text
        FROM sqla$sqltext
       WHERE snap_id = p_snap_id
         AND top     = p_top_snap
       ORDER BY
             piece;

   CURSOR c3_explain_plan IS
      SELECT '|'||
             LPAD(TO_CHAR(id),4)||
             LPAD(' ',depth,RPAD(' ',100,'....|'))||
             operation||' '||
             DECODE(options,NULL,NULL,'('||options||') ')||
             DECODE(object_owner,NULL,NULL,'OF '''||object_owner||'.')||
             DECODE(object_name,NULL,NULL,object_name||''' ')||
             DECODE(object_type,NULL,NULL,'('||object_type||') ')||
             DECODE(NVL(cost,0)+NVL(cardinality,0)+NVL(bytes,0),0,NULL,
             ' ('||DECODE(cost,NULL,NULL,'COST='||TO_CHAR(cost)||' ')||
             DECODE(cardinality,NULL,NULL,'CARD='||TO_CHAR(cardinality)||' ')||
             DECODE(bytes,NULL,NULL,'BYTES='||TO_CHAR(bytes))||')')||
             DECODE(object_node,NULL,NULL,' ['||object_node||'] ')||
             ' '||DBMS_LOB.SUBSTR(other,DBMS_LOB.GETLENGTH(other),1)||
             distribution||
             DECODE(other_tag,NULL,NULL,' '||other_tag||
             '[START:'||partition_start||
             ' STOP:'||partition_stop||
             ' ID:'||TO_CHAR(partition_id)||']')
             plan_line
        FROM sqla$plan_table
       WHERE snap_id = p_snap_id
         AND top     = p_top_snap
       ORDER BY
             id;

   CURSOR c4_children IS
      SELECT child_number,
             buffer_gets,
             disk_reads,
             plan_hash_value,
             optimizer_cost,
             DECODE(optimizer_cost,0,' (RBO)') rbo
        FROM sqla$sql
      WHERE snap_id = p_snap_id
        AND top     = p_top_snap
        AND plan_hash_value <> 0
      ORDER BY
            child_number;

   CURSOR c5_sql_plan (c_child_number NUMBER) IS
      SELECT '|'||
             LPAD(TO_CHAR(id),4)||
             LPAD(' ',depth+1,RPAD(' ',100,'....|'))||
             operation||' '||
             DECODE(options,NULL,NULL,'('||options||') ')||
             DECODE(object_owner,NULL,NULL,'OF '''||object_owner||'.')||
             DECODE(object_name,NULL,NULL,object_name||''' ')||
             DECODE(NVL(search_columns,0),0,NULL,'SEARCH_COLUMNS='||TO_CHAR(search_columns)||' ')||
             DECODE(NVL(cost,0)+NVL(cardinality,0)+NVL(bytes,0),0,NULL,
             ' ('||
             DECODE(cost,NULL,NULL,'COST='||TO_CHAR(cost)||' ')||
             DECODE(cardinality,NULL,NULL,'CARD='||TO_CHAR(cardinality)||' ')||
             DECODE(bytes,NULL,NULL,'BYTES='||TO_CHAR(bytes)||' ')||
             DECODE(cpu_cost,NULL,NULL,'CPU_COST='||TO_CHAR(cpu_cost)||' ')||
             DECODE(io_cost,NULL,NULL,'IO_COST='||TO_CHAR(io_cost)||' ')||
             DECODE(temp_space,NULL,NULL,'TEMP_SPACE='||TO_CHAR(temp_space))||
             ')')||
             DECODE(object_node,NULL,NULL,' ['||object_node||'] ')||
             DECODE(other,NULL,NULL,' '||other)||
             DECODE(distribution,NULL,NULL,' '||distribution)||
             DECODE(other_tag,NULL,NULL,' '||other_tag||
             '[START:'||partition_start||
             ' STOP:'||partition_stop||
             ' ID:'||TO_CHAR(partition_id)||']')
             plan_line
        FROM sqla$sql_plan
       WHERE snap_id      = p_snap_id
         AND top          = p_top_snap
         AND child_number = c_child_number
       ORDER BY
             id;

   CURSOR c6_sql_plan_statistics_last (c_child_number NUMBER) IS
      SELECT RPAD('|'||
             LPAD(TO_CHAR(sp.id),4)||
             LPAD(' ',sp.depth+1,RPAD(' ',100,'....|'))||
             sp.operation||' '||
             DECODE(sp.options,NULL,NULL,'('||sp.options||') ')||
             DECODE(sp.object_name,NULL,NULL,sp.object_name),50)||
             LPAD(TO_CHAR(sps.last_starts),10)||
             LPAD(TO_CHAR(sps.last_output_rows),10)||
             LPAD(TO_CHAR(sps.last_cr_buffer_gets),10)||
             LPAD(TO_CHAR(sps.last_cu_buffer_gets),10)||
             LPAD(TO_CHAR(sps.last_disk_reads),10)||
             LPAD(TO_CHAR(sps.last_disk_writes),10)||
             LPAD(TO_CHAR(ROUND(sps.last_elapsed_time/1000000,2),'FM9999990.00'),10)
             line
        FROM sqla$sql_plan            sp,
             sqla$sql_plan_statistics sps
       WHERE sp.snap_id      = p_snap_id
         AND sp.top          = p_top_snap
         AND sp.child_number = c_child_number
         AND sp.snap_id      = sps.snap_id
         AND sp.top          = sps.top
         AND sp.child_number = sps.child_number
         AND sp.id           = sps.operation_id
       ORDER BY
             sp.id;

   CURSOR c7_sql_plan_statistics_all (c_child_number NUMBER) IS
      SELECT RPAD('|'||
             LPAD(TO_CHAR(sp.id),4)||
             LPAD(' ',sp.depth+1,RPAD(' ',100,'....|'))||
             sp.operation||' '||
             DECODE(sp.options,NULL,NULL,'('||sp.options||') ')||
             DECODE(sp.object_name,NULL,NULL,sp.object_name),50)||
             LPAD(TO_CHAR(sps.starts),10)||
             LPAD(TO_CHAR(sps.output_rows),10)||
             LPAD(TO_CHAR(sps.cr_buffer_gets),10)||
             LPAD(TO_CHAR(sps.cu_buffer_gets),10)||
             LPAD(TO_CHAR(sps.disk_reads),10)||
             LPAD(TO_CHAR(sps.disk_writes),10)||
             LPAD(TO_CHAR(ROUND(sps.elapsed_time/1000000,2),'FM9999990.00'),10)
             line
        FROM sqla$sql_plan            sp,
             sqla$sql_plan_statistics sps
       WHERE sp.snap_id      = p_snap_id
         AND sp.top          = p_top_snap
         AND sp.child_number = c_child_number
         AND sp.snap_id      = sps.snap_id
         AND sp.top          = sps.top
         AND sp.child_number = sps.child_number
         AND sp.id           = sps.operation_id
       ORDER BY
             sp.id;

   CURSOR c8_sql_workarea (c_child_number NUMBER) IS
      SELECT '|'||LPAD(TO_CHAR(operation_id),4)||
             LPAD(policy,7)||
             LPAD(TO_CHAR(estimated_optimal_size),10)||
             LPAD(TO_CHAR(estimated_onepass_size),10)||
             LPAD(TO_CHAR(last_memory_used),10)||
             LPAD(last_execution,10)||
             LPAD(TO_CHAR(last_degree),7)||
             LPAD(TO_CHAR(total_executions),10)||
             LPAD(TO_CHAR(optimal_executions),10)||
             LPAD(TO_CHAR(onepass_executions),10)||
             LPAD(TO_CHAR(multipasses_executions),10)||
             LPAD(TO_CHAR(ROUND(active_time/1000000,2),'FM9999990.00'),10)||
             LPAD(TO_CHAR(max_tempseg_size),10)||
             LPAD(TO_CHAR(last_tempseg_size),10)
             line
        FROM sqla$sql_workarea
       WHERE snap_id      = p_snap_id
         AND top          = p_top_snap
         AND child_number = c_child_number
       ORDER BY
             operation_id;

   CURSOR c9_tables IS
      SELECT owner,
             table_name,
             num_rows,
             blocks,
             sample_size,
             last_analyzed
        FROM sqla$tables
       WHERE snap_id = p_snap_id
         AND ( owner, table_name ) IN
             ( SELECT object_owner owner, object_name table_name
                 FROM sqla$plan_table
                WHERE snap_id   = p_snap_id
                  AND top       = p_top_snap
                  AND operation = 'TABLE ACCESS'
                UNION
               SELECT object_owner owner, object_name table_name
                 FROM sqla$sql_plan
                WHERE snap_id   = p_snap_id
                  AND top       = p_top_snap
                  AND operation = 'TABLE ACCESS'
                UNION
               SELECT table_owner owner, table_name
                 FROM sqla$indexes
                WHERE snap_id = p_snap_id
                  AND ( owner, index_name ) IN
                      ( SELECT object_owner owner, object_name index_name
                          FROM sqla$plan_table
                         WHERE snap_id   = p_snap_id
                           AND top       = p_top_snap
                           AND operation LIKE '%INDEX%'
                         UNION
                        SELECT object_owner owner, object_name index_name
                          FROM sqla$sql_plan
                         WHERE snap_id   = p_snap_id
                           AND top       = p_top_snap
                           AND operation LIKE '%INDEX%'
                       )
              )
        ORDER BY
              owner, table_name;

   CURSOR c10_indexes (c_table_owner VARCHAR2, c_table_name VARCHAR2) IS
      SELECT owner,
             index_name,
             num_rows,
             leaf_blocks,
             sample_size,
             last_analyzed
        FROM sqla$indexes
       WHERE snap_id     = p_snap_id
         AND table_owner = c_table_owner
         AND table_name  = c_table_name
       ORDER BY
             owner, index_name;

   CURSOR c11_indexes IS
      SELECT table_owner,
             table_name,
             owner,
             index_name,
             uniqueness,
             indexed_columns
        FROM sqla$indexes
       WHERE snap_id = p_snap_id
         AND ( owner, index_name ) IN
             ( SELECT object_owner owner, object_name index_name
                 FROM sqla$plan_table
                WHERE snap_id   = p_snap_id
                  AND top       = p_top_snap
                  AND operation LIKE '%INDEX%'
                UNION
               SELECT object_owner owner, object_name index_name
                 FROM sqla$sql_plan
                WHERE snap_id   = p_snap_id
                  AND top       = p_top_snap
                  AND operation LIKE '%INDEX%'
              )
       UNION
      SELECT table_owner,
             table_name,
             owner,
             index_name,
             uniqueness,
             indexed_columns
        FROM sqla$indexes
       WHERE snap_id = p_snap_id
         AND ( table_owner, table_name ) IN
             ( SELECT object_owner owner, object_name table_name
                 FROM sqla$plan_table
                WHERE snap_id   = p_snap_id
                  AND top       = p_top_snap
                  AND operation = 'TABLE ACCESS'
                UNION
               SELECT object_owner owner, object_name table_name
                 FROM sqla$sql_plan
                WHERE snap_id   = p_snap_id
                  AND top       = p_top_snap
                  AND operation = 'TABLE ACCESS'
              )
       ORDER BY
             table_owner, table_name, owner, index_name;

   CURSOR c12_session_process IS
      SELECT logon_time,
             sid,
             audsid,
             process,
             pid,
             spid,
             apps_user_name,
             apps_module
        FROM sqla$session_process
       WHERE snap_id = p_snap_id
         AND top     = p_top_snap
       ORDER BY
             logon_time;

BEGIN /* put_cursor */
   IF p_top_range IS NOT NULL THEN
      l_top_range := 'TOP_RANGE:'||TO_CHAR(p_top_range)||'  ';
   END IF;

   PUT_LINE('<a name="'||TO_CHAR(p_snap_id)||'-'||TO_CHAR(p_top_snap)||'"></a>');

   FOR c1 IN c1_sqlarea LOOP
      PUT_LINE(l_top_range||
                 'SNAP_ID:'||TO_CHAR(p_snap_id)||
               '  TOP_SNAP:'||TO_CHAR(p_top_snap)||
               '  BUFFER_GETS:'||TO_CHAR(c1.buffer_gets)||
               '  DISK_READS:'||TO_CHAR(c1.disk_reads)||
               '  HASH_VALUE:'||TO_CHAR(c1.hash_value)||
               '  ADDRESS:'||c1.address);
      PUT_LINE(CHR(0));

      FOR c2 IN c2_sqltext LOOP
         PUT_LINE(REPLACE(REPLACE(c2.sql_text,'>','&gt;'),'<','&lt;'));
      END LOOP;

      IF  c1.explain_plan_error IS NOT NULL THEN
         PUT_LINE(CHR(0));
         PUT_LINE('CANNOT CREATE EXPLAIN PLAN: '||c1.explain_plan_error);
      ELSE
         FOR c3 IN c3_explain_plan LOOP
            IF c3_explain_plan%ROWCOUNT = 1 THEN
               PUT_LINE(CHR(0));
               PUT_LINE('|OPER EXEC');
               PUT_LINE('|  ID  ORD EXPLAINED ACCESS PATH (EXPLAIN PLAN)');
               PUT_LINE('+---- ---- ----------------------------------------------------------');
            END IF;
            PUT_LINE(c3.plan_line);
         END LOOP;
      END IF;

      FOR c4 IN c4_children LOOP
        PUT_LINE(CHR(0));
        PUT_LINE(l_top_range||
                   'SNAP_ID:'||TO_CHAR(p_snap_id)||
                 '  TOP_SNAP:'||TO_CHAR(p_top_snap)||
                 '  CHILD:'||TO_CHAR(c4.child_number)||
                 '  BUFFER_GETS:'||TO_CHAR(c4.buffer_gets)||
                 '  DISK_READS:'||TO_CHAR(c4.disk_reads)||
                 '  PLAN_HASH_VALUE:'||TO_CHAR(c4.plan_hash_value)||
                 '  COST:'||TO_CHAR(c4.optimizer_cost)||c4.rbo);

         FOR c5 IN c5_sql_plan(c4.child_number) LOOP
            IF c5_sql_plan%ROWCOUNT = 1 THEN
               PUT_LINE(CHR(0));
               PUT_LINE('|OPER EXEC');
               PUT_LINE('|  ID  ORD RUNTIME ACCESS PATH (ACTUAL EXCECUTION PLAN)');
               PUT_LINE('+---- ---- ----------------------------------------------------------');
            END IF;
            PUT_LINE(c5.plan_line);
         END LOOP;

         FOR c6 IN c6_sql_plan_statistics_last(c4.child_number) LOOP
            IF c6_sql_plan_statistics_last%ROWCOUNT = 1 THEN
               PUT_LINE(CHR(0));
               PUT_LINE(l_top_range||
                          'SNAP_ID:'||TO_CHAR(p_snap_id)||
                        '  TOP_SNAP:'||TO_CHAR(p_top_snap)||
                        '  CHILD:'||TO_CHAR(c4.child_number)||
                        '  PLAN STATISTICS FOR LAST EXECUTION');
               PUT_LINE(CHR(0));
               PUT_LINE(RPAD('|OPER',50)||
                        '              OUTPUT CR BUFFER CU BUFFER      DISK      DISK   ELAPSED');
               PUT_LINE(RPAD('|  ID OPERATION (OPTIONS) OBJECT_NAME',50)||
                        '    STARTS      ROWS      GETS      GETS     READS    WRITES      TIME');
               PUT_LINE(RPAD('+---- -',50,'-')||
                        ' --------- --------- --------- --------- --------- --------- ---------');
            END IF;
            PUT_LINE(c6.line);
         END LOOP;

         FOR c7 IN c7_sql_plan_statistics_all(c4.child_number) LOOP
            IF c7_sql_plan_statistics_all%ROWCOUNT = 1 THEN
               PUT_LINE(CHR(0));
               PUT_LINE(l_top_range||
                        'SNAP_ID:'||TO_CHAR(p_snap_id)||
                        '  TOP_SNAP:'||TO_CHAR(p_top_snap)||
                        '  CHILD:'||TO_CHAR(c4.child_number)||
                        '  PLAN STATISTICS FOR ALL EXECUTIONS');
               PUT_LINE(CHR(0));
               PUT_LINE(RPAD('|OPER',50)||
                        '              OUTPUT CR BUFFER CU BUFFER      DISK      DISK   ELAPSED');
               PUT_LINE(RPAD('|  ID OPERATION (OPTIONS) OBJECT_NAME',50)||
                        '    STARTS      ROWS      GETS      GETS     READS    WRITES      TIME');
               PUT_LINE(RPAD('+---- -',50,'-')||
                        ' --------- --------- --------- --------- --------- --------- ---------');
            END IF;
            PUT_LINE(c7.line);
         END LOOP;

         FOR c8 IN c8_sql_workarea(c4.child_number) LOOP
            IF c8_sql_workarea%ROWCOUNT = 1 THEN
               PUT_LINE(CHR(0));
               PUT_LINE(l_top_range||
                          'SNAP_ID:'||TO_CHAR(p_snap_id)||
                        '  TOP_SNAP:'||TO_CHAR(p_top_snap)||
                        '  CHILD:'||TO_CHAR(c4.child_number)||
                        '  WORKAREAS');
               PUT_LINE(CHR(0));
               PUT_LINE('|            ESTIMATED ESTIMATED      LAST                           '||
                        '                         MULTI            MAX TEMP LAST TEMP');
               PUT_LINE('|OPER          OPTIMAL  ONE PASS    MEMORY      LAST   LAST     TOTAL'||
                        '   OPTIMAL  ONE PASS    PASSES    ACTIVE   SEGMENT   SEGMENT');
               PUT_LINE('|  ID POLICY      SIZE      SIZE      USED EXECUTION DEGREE  EXECUTNS'||
                        '  EXECUTNS  EXECUTNS  EXECUTNS      TIME      SIZE      SIZE');
               PUT_LINE('+---- ------ --------- --------- --------- --------- ------ ---------'||
                        ' --------- --------- --------- --------- --------- ---------');
            END IF;
            PUT_LINE(c8.line);
         END LOOP;
      END LOOP;

      FOR c9 IN c9_tables LOOP
         IF c9_tables%ROWCOUNT = 1 THEN
            PUT_LINE(CHR(0));
            PUT_LINE('OWNER.TABLE_NAME');
            PUT_LINE(RPAD('...owner.index_name', 53)||'   num rows     blocks     sample last analyzed date ');
            PUT_LINE(RPAD('-', 53, '-')       ||' ---------- ---------- ---------- -------------------');
         END IF;
         PUT_LINE(RPAD(SUBSTR(c9.owner||'.'||c9.table_name, 1, 53), 53, '.')||
                  LPAD(TO_CHAR(ROUND(c9.num_rows)), 11)||
                  LPAD(TO_CHAR(ROUND(c9.blocks)), 11)||
                  LPAD(TO_CHAR(ROUND(c9.sample_size)), 11)||
                  TO_CHAR(c9.last_analyzed, ' YYYY-MM-DD HH24:MI:SS'));
         FOR c10 IN c10_indexes(c9.owner, c9.table_name) LOOP
            PUT_LINE(RPAD(SUBSTR('...'||LOWER( c10.owner)||'.'||LOWER(c10.index_name), 1, 53), 53, '.')||
                     LPAD(TO_CHAR(ROUND(c10.num_rows)), 11)||
                     LPAD(TO_CHAR(ROUND(c10.leaf_blocks)), 11)||
                     LPAD(TO_CHAR(ROUND(c10.sample_size)), 11)||
                     TO_CHAR(c10.last_analyzed, ' YYYY-MM-DD HH24:MI:SS'));
         END LOOP;
      END LOOP;

      FOR c11 IN c11_indexes LOOP
         IF c11_indexes%ROWCOUNT = 1 THEN
            PUT_LINE(CHR(0));
            PUT_LINE('INDEX_NAME (UNIQUENESS) [indexed columns]');
            PUT_LINE(RPAD('-', 115, '-'));
         END IF;
         PUT_LINE(c11.index_name||
                  ' ('||c11.uniqueness||')'||
                  ' ['||LOWER( c11.indexed_columns )||']');
      END LOOP;

      FOR c12 IN c12_session_process LOOP
         IF c12_session_process%ROWCOUNT = 1 THEN
            PUT_LINE(CHR(0));
            PUT_LINE('LOGON_TIME                  SID      AUDSID     PROCESS         PID        SPID');
            PUT_LINE('------------------- ----------- ----------- ----------- ----------- -----------');
         END IF;

         l_text := TO_CHAR(c12.logon_time, 'YYYY-MM-DD HH24:MI:SS')||
                   LPAD(TO_CHAR(c12.sid),12)||
                   LPAD(TO_CHAR(c12.audsid),12)||
                   LPAD(c12.process,12)||
                   LPAD(TO_CHAR(c12.pid),12)||
                   LPAD(c12.spid,12);

         IF c12.apps_user_name IS NOT NULL THEN
            l_text := l_text||
                      '  USER: '||c12.apps_user_name||
                      '  MODULE: '||c12.apps_module;
         END IF;

         PUT_LINE(l_text);
      END LOOP;

      PUT_STARS;
   END LOOP;
END put_cursor;

/*******************************************************************************/

PROCEDURE put_cursors_snap
( p_snap_id         IN  NUMBER
 ) IS
   CURSOR c1_cursors IS
      SELECT top
        FROM sqla$sqlarea
       WHERE snap_id = p_snap_id
       ORDER BY
             top;

BEGIN /* put_cursors_snap */
   PUT_STARS;
   FOR c1 IN c1_cursors LOOP
      PUT_CURSOR(NULL, p_snap_id, c1.top);
   END LOOP;
END put_cursors_snap;

/*******************************************************************************/

PROCEDURE put_cursors_range
( p_range_id         IN  NUMBER
 ) IS
   CURSOR c1_cursors IS
      SELECT top_range, snap_id, top_snap
        FROM sqla$range
       WHERE range_id = p_range_id
       ORDER BY
             top_range;

BEGIN /* put_cursors_range */
   PUT_STARS;
   FOR c1 IN c1_cursors LOOP
      PUT_CURSOR(c1.top_range, c1.snap_id, c1.top_snap);
   END LOOP;
END put_cursors_range;

/*******************************************************************************/

END sqla$;
/

SET DEF ON;
PRO
PRO SQLA$ Package Body has been created
PRO

SHOW ERRORS PACKAGE BODY sqla$;

