/* $Header: sqlagrnt.sql 238684.1 2003/11/21 12:00:00 pkm ship $ */
SET DOC OFF;
/*============================================================================+
|    Copyright (c) 2003 Oracle Corporation Redwood Shores, California, USA    |
|                              All rights reserved.                           |
+=============================================================================+
|
| FILENAME
|
|   sqlagrnt.sql - Grants Object Privileges to USER of SQL Area scripts
|
|
| USAGE
|
|   Connect into SQL*Plus as privileged USER which can issue GRANT statements
|   below (usually SYSTEM or SYS)
|
|      SQL> START sqlagrnt.sql <user>;
|
|
| DESCRIPTION
|
|   Use only if you get any error like these while executing sqlapkgb.sql:
|
|      PLS-00201: identifier 'SYS.DBA_TABLES' must be declared
|      PLS-00201: identifier 'SYS.V_$PARAMETER' must be declared
|
|   This script requires one parameter:
|
|   1. user: Database user who will execute SQL Area script sqlareat.sql
|
|
| NOTES
|
|   This script is part of a set compressed into file SQLA.zip.  Latest version
|   of SQLA.zip can be downloaded from Note:238684.1
|
|   If you ever executed sqlagrnt.sql, use sqlarevk.sql when uninstalling
|
|   Read Note:238684.1 for further details.
|
|
+============================================================================*/


DEF p_user = &1;

GRANT SELECT ON sys.audit_actions              TO &&p_user;
GRANT SELECT ON sys.dba_ind_columns            TO &&p_user;
GRANT SELECT ON sys.dba_indexes                TO &&p_user;
GRANT SELECT ON sys.dba_tables                 TO &&p_user;
GRANT SELECT ON sys.dba_users                  TO &&p_user;
GRANT SELECT ON sys.v_$database                TO &&p_user;
GRANT SELECT ON sys.v_$instance                TO &&p_user;
GRANT SELECT ON sys.v_$librarycache            TO &&p_user;
GRANT SELECT ON sys.v_$open_cursor             TO &&p_user;
GRANT SELECT ON sys.v_$parameter               TO &&p_user;
GRANT SELECT ON sys.v_$process                 TO &&p_user;
GRANT SELECT ON sys.v_$session                 TO &&p_user;
GRANT SELECT ON sys.v_$sgastat                 TO &&p_user;
GRANT SELECT ON sys.v_$sql                     TO &&p_user;
GRANT SELECT ON sys.v_$sql_plan                TO &&p_user;
GRANT SELECT ON sys.v_$sql_plan_statistics     TO &&p_user;
GRANT SELECT ON sys.v_$sql_workarea            TO &&p_user;
GRANT SELECT ON sys.v_$sqlarea                 TO &&p_user;
GRANT SELECT ON sys.v_$sqltext                 TO &&p_user;

UNDEF 1 p_user;