/* $Header: sqlapurg.sql 238684.1 2003/11/21 12:00:00 pkm ship $ */
SET DOC OFF;
/*============================================================================+
|    Copyright (c) 2003 Oracle Corporation Redwood Shores, California, USA    |
|                              All rights reserved.                           |
+=============================================================================+
|
| FILENAME
|
|   sqlapurg.sql - Purges Staging Repository of 'SQL Area Top DML'
|
|
| USAGE
|
|   Connect into SQL*Plus as USER who installed 'SQL Area Top DML'
|
|      SQL> START sqlarea-purge.sql <p_days_to_keep_repo>;
|
|
| DESCRIPTION
|
|   This script has one seeded parameter:
|
|   1. p_days_to_keep_repo: Number of days to keep data on staging Repository.
|                           Repository rows before this thershold are purged.
|
|
| NOTES
|
|   This script is part of a set compressed into file SQLA.zip.  Latest version
|   of SQLA.zip can be downloaded from Note:238684.1
|
|   If all snaphots stored on Repository are older than thershold, staging
|   tables get truncated instead of purged.
|
|   Analyzer script sqlareat.sql executes this script every time.
|
|   Read Note:238684.1 for further details.
|
|
+============================================================================*/


DEF p_days_to_keep_repo  = &1

EXEC SQLA$.PURGE_REPO(TO_NUMBER('&&p_days_to_keep_repo'));

UNDEF 1;
