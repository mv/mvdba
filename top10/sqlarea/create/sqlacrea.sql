/* $Header: sqlacrea.sql 238684.1 2003/11/21 12:00:00 pkm ship $ */
SET DOC OFF;
/*============================================================================+
|    Copyright (c) 2003 Oracle Corporation Redwood Shores, California, USA    |
|                              All rights reserved.                           |
+=============================================================================+
|
| FILENAME
|
|   sqlacrea.sql - Creates Schema Objects for 'SQL Area Top DML'
|
|
| USAGE
|
|   Connect into SQL*Plus as USER who will be executing the 'SQL Area Top DML'
|   If used on an Oracle Applications database, connect as APPS.  Otherwise,
|   connect as main application user whith access to most schema objects
|   including DBA and V$ views.  It can also be installed and used connecting
|   as SYSTEM, but Explain Plans on 8i would not be generated for application
|   code.
|
|      SQL> START sqlacrea.sql;
|
|
| DESCRIPTION
|
|   This script creates the staging repository to be used by 'SQL Area Top DML'
|
|   sqlacrea.sql executes other scripts which should be on same directory.  It
|   drops first the existing repository (in case this is a re-install), then it
|   creates some tables, indexes and then a package.  If used in UNIX, keep all
|   script filenames in UPPERCASE.
|
|
| NOTES
|
|   This script is part of a set compressed into file SQLA.zip.  Latest version
|   of SQLA.zip can be downloaded from Note:238684.1
|
|   When used for the first time, sqlareat.sql executes automatically the
|   installation script sqlacrea.sql.
|
|   If re-installing or installing manually, execute script sqlacrea.sql to
|   create the schema objects required by sqlareat.sql.
|
|   If you need to uninstall this tool, execute command below and remove
|   scripts SQLA* from dedicated directory
|
|      SQL> START sqladrop.sql;
|
|   Read Note:238684.1 for further details.
|
|
+============================================================================*/


SET ECHO ON;
SPO sqlacrea.log;

@@ sqladrop.sql
@@ sqlarepo.sql
@@ sqlapkgs.sql
@@ sqlapkgb.sql

SPO OFF;
SET ECHO OFF;

PRO
PRO SQLA$ Staging Repository and Package have been created
PRO
