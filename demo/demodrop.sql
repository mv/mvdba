--
-- Copyright (c) Oracle Corporation 1988, 2000.  All Rights Reserved.
--
-- NAME
--   demodrop.sql
--
-- DESCRIPTION
--   This script drops the SQL*Plus demonstration tables created by
--   demobld.sql.  It should be STARTed by each owner of the tables.
--
-- USAGE
--   From within SQL*Plus, enter:
--       START demodrop.sql

SET TERMOUT ON
PROMPT Dropping demonstration tables.  Please wait.
SET TERMOUT OFF

DROP TABLE EMP;
DROP TABLE DEPT;
DROP TABLE BONUS;
DROP TABLE SALGRADE;
DROP TABLE DUMMY;

SET TERMOUT ON
PROMPT Demonstration table drop is complete.

EXIT
