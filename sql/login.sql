--
-- NAME
--   login.sql
--
-- DESCRIPTION
--   SQL*Plus user login file
--
--   Add any SQL*Plus commands here that are to be executed when a
--   user starts SQL*Plus, or uses the SQL*Plus CONNECT command
--
-- USAGE
--   Put this in any dir listed in SQLPATH
--   $ export SQLPATH=~:~/sql:/u01/app/oracle/sql
--
-- Marcus Vinicius Ferreira                 ferreira.mv[ at ]gmail.com
-- 2009/Jun
--

-- glogin.sql :: Oracle 10g 10.2.0.4 MacOS {

    -- Used by Trusted Oracle
    COLUMN ROWLABEL FORMAT A15

    -- Used for the SHOW ERRORS command
    COLUMN LINE/COL FORMAT A8
    COLUMN ERROR    FORMAT A65  WORD_WRAPPED

    -- Used for the SHOW SGA command
    COLUMN name_col_plus_show_sga FORMAT a24
    COLUMN units_col_plus_show_sga FORMAT a15
    -- Defaults for SHOW PARAMETERS
    COLUMN name_col_plus_show_param FORMAT a36 HEADING NAME
    COLUMN value_col_plus_show_param FORMAT a30 HEADING VALUE

    -- Defaults for SHOW RECYCLEBIN
    COLUMN origname_plus_show_recyc   FORMAT a16 HEADING 'ORIGINAL NAME'
    COLUMN objectname_plus_show_recyc FORMAT a30 HEADING 'RECYCLEBIN NAME'
    COLUMN objtype_plus_show_recyc    FORMAT a12 HEADING 'OBJECT TYPE'
    COLUMN droptime_plus_show_recyc   FORMAT a19 HEADING 'DROP TIME'

    -- Defaults for SET AUTOTRACE EXPLAIN report
    -- These column definitions are only used when SQL*Plus
    -- is connected to Oracle 9.2 or earlier.
    COLUMN  id_plus_exp           FORMAT  990  HEADING  i
    COLUMN  parent_id_plus_exp    FORMAT  990  HEADING  p
    COLUMN  plan_plus_exp         FORMAT  a60
    COLUMN  object_node_plus_exp  FORMAT  a8
    COLUMN  other_tag_plus_exp    FORMAT  a29
    COLUMN  other_plus_exp        FORMAT  a44

    -- Default for XQUERY
    COLUMN result_plus_xquery HEADING 'Result Sequence'
-- }

-- DateMask {
    SET TERMOUT OFF
    --SAVE /tmp/afiedt.current.sql REPLACE
        ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
    --GET  /tmp/afiedt.current.sql
    SET TERMOUT ON
-- }

-- Spool Results {
    SET SERVEROUTPUT    ON SIZE UNLIMITED
    SET PAGESIZE        200
    SET LINESIZE        1000
    SET TRIMOUT         ON
    SET TRIMSPOOL       ON
    SET WRAP            ON
    -- DBMS_METADATA
    SET LONG            102400
    SET LONGCHUNKSIZE   102400
-- }

-- Pretty::Globals {
    SET NUMWIDTH        15
    COLUMN cmd          FORMAT A120
    COLUMN qtd          FORMAT 999g999g990d00
    COLUMN count(1)     FORMAT 999g999g990d00
    COLUMN count(*)     FORMAT 999g999g990d00
    COLUMN count(rowid) FORMAT 999g999g990d00
-- }

-- Pretty::DBA Views {
    -- Constraints
    COLUMN search_condition FORMAT A30

    -- Objects
    COLUMN owner        FORMAT A30
    COLUMN object_name  FORMAT A30

    -- DB_Links
    COLUMN db           FORMAT A20
    COLUMN db_link      FORMAT A20
    COLUMN global_name  FORMAT A20
    COLUMN host         FORMAT A20

    -- Sessions
    COLUMN username     FORMAT A30
    COLUMN module       FORMAT A20
    COLUMN action       FORMAT A20

    -- Users
    COLUMN username             FORMAT a20
    COLUMN password             FORMAT a16
    COLUMN account_status       FORMAT a16
    COLUMN default_tablespace   FORMAT a20
    COLUMN temporary_tablespace FORMAT a20
    COLUMN external_name        FORMAT a15

-- }

-- Trace/Tuning {
    SET APPINFO         ON
    SET AUTOPRINT       ON
    --T AUTOTRACE       p
    SET TIMING          ON
    SET TIME            ON
-- }

-- Describe Nested Objects {
    SET DESCRIBE        DEPTH 4
    SET DESCRIBE        INDENT ON
    SET DESCRIBE        LINE OFF
-- }

-- Pretty::Prompt {

    -- == 10g
    SET SQLPROMPT       "- &&_user@&&_connect_identifier > "

    -- == Pre-10g
--     UNDEFINE usr db
--     col usr new_value usr
--     col db  new_value db
--
--     SET TERMOUT OFF
--     select lower(user) AS usr
--          , lower(decode( instr(global_name, '.' )
--                        , 0 , global_name
--                        , substr(global_name, 1, instr(global_name, '.')-1))
--             )          AS db
--       from global_name -- v$database
-- /
--     SET TERMOUT ON
--     SET SQLPROMPT   '- &&usr.@&&db. > '
--     UNDEFINE usr db
    -- == Pre-10g - END

-- }

-- Simple::Documentation {
    -- == & , **
    -- SET DEFINE OFF
    -- SET SCAN OFF
-- }

DEFINE _EDITOR='vim -c "set filetype=plsql"'

-- vim: ft=plsql foldlevel=0:

