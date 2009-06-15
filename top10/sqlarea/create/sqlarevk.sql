/* $Header: sqlarevk.sql 238684.1 2003/11/21 12:00:00 pkm ship $ */
SET DOC OFF;
/*============================================================================+
|    Copyright (c) 2003 Oracle Corporation Redwood Shores, California, USA    |
|                              All rights reserved.                           |
+=============================================================================+
|
| FILENAME
|
|   sqlarevk.sql - Revokes Object Privileges to USER of SQL Area scripts
|
|
| USAGE
|
|   Connect into SQL*Plus as privileged USER which can issue REVOKE statements
|   below (usually SYSTEM or SYS)
|
|      SQL> START sqlarevk.sql <user>;
|
|
| DESCRIPTION
|
|   Use this script only if uninstalling sqlareat.sql and Staging Repository,
|   and sqlagrnt.sql was ever executed.
|
|   This script requires one parameter:
|
|   1. user: Database user who was executing SQL Area script sqlareat.sql.
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

REVOKE SELECT ON sys.audit_actions              FROM &&p_user;
REVOKE SELECT ON sys.dba_ind_columns            FROM &&p_user;
REVOKE SELECT ON sys.dba_indexes                FROM &&p_user;
REVOKE SELECT ON sys.dba_tables                 FROM &&p_user;
REVOKE SELECT ON sys.dba_users                  FROM &&p_user;
REVOKE SELECT ON sys.v_$database                FROM &&p_user;
REVOKE SELECT ON sys.v_$instance                FROM &&p_user;
REVOKE SELECT ON sys.v_$librarycache            FROM &&p_user;
REVOKE SELECT ON sys.v_$open_cursor             FROM &&p_user;
REVOKE SELECT ON sys.v_$parameter               FROM &&p_user;
REVOKE SELECT ON sys.v_$process                 FROM &&p_user;
REVOKE SELECT ON sys.v_$session                 FROM &&p_user;
REVOKE SELECT ON sys.v_$sgastat                 FROM &&p_user;
REVOKE SELECT ON sys.v_$sql                     FROM &&p_user;
REVOKE SELECT ON sys.v_$sql_plan                FROM &&p_user;
REVOKE SELECT ON sys.v_$sql_plan_statistics     FROM &&p_user;
REVOKE SELECT ON sys.v_$sql_workarea            FROM &&p_user;
REVOKE SELECT ON sys.v_$sqlarea                 FROM &&p_user;
REVOKE SELECT ON sys.v_$sqltext                 FROM &&p_user;

UNDEF 1 p_user;
