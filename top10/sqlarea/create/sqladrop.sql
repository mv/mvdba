/* $Header: sqladrop.sql 238684.1 2003/11/21 12:00:00 pkm ship $ */
SET DOC OFF;
/*============================================================================+
|    Copyright (c) 2003 Oracle Corporation Redwood Shores, California, USA    |
|                              All rights reserved.                           |
+=============================================================================+
|
| FILENAME
|
|   sqladrop.sql - Drops Schema Objects used by the 'SQL Area Top DML' tool
|
|
| USAGE
|
|   Connect into SQL*Plus as USER who installed the 'SQL Area Top DML' tool
|
|      SQL> START sqladrop.sql;
|
|
| DESCRIPTION
|
|   This script drops the staging repository used by the 'SQL Area Top DML'
|   sqlareat.sql.  Use only if un-installing the 'SQL Area Top DML' tool.
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
PRO ***************************************************************************
PRO
PRO Dropping current SQLA$ Repository (some errors are expected)
PRO

SET ECHO ON;

DROP PACKAGE   sqla$;

DROP VIEW      sqla$active_form;
DROP VIEW      sqla$active_conc_request;

DROP TABLE     sqla$snap;
DROP TABLE     sqla$sqlarea;
DROP TABLE     sqla$sql;
DROP TABLE     sqla$sqltext;
DROP TABLE     sqla$plan_table;
DROP TABLE     sqla$sql_plan;
DROP TABLE     sqla$sql_plan_statistics;
DROP TABLE     sqla$sql_workarea;
DROP TABLE     sqla$tables;
DROP TABLE     sqla$indexes;
DROP TABLE     sqla$session_process;
DROP TABLE     sqla$range;

DROP SEQUENCE  sqla$snap_seq;
DROP SEQUENCE  sqla$range_seq;

SET ECHO OFF;

PRO
PRO SQLA$ Repository has been dropped
PRO

