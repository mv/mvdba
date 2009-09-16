------------------------------------------------------------------------------
-- Filename:	disprate.sql
-- Purpose:	queries v$dispatcher_rate
------------------------------------------------------------------------------

col name format a8

col CUR_MSG_RATE			format 999999
col MAX_MSG_RATE			format 999999
col AVG_MSG_RATE			format 999999

SELECT	name,
CUR_MSG_RATE,
MAX_MSG_RATE,
AVG_MSG_RATE
FROM v$dispatcher_rate
/

col CUR_SVR_BYTE_PER_BUF	format 999999 heading "CUR|SVR|BYTE|PER|BUF"
col CUR_CLT_BYTE_PER_BUF	format 999999 heading "CUR|CLT|BYTE|PER|BUF"
col MAX_SVR_BYTE_PER_BUF	format 999999 heading "MAX|SVR|BYTE|PER|BUF"
col MAX_CLT_BYTE_PER_BUF	format 999999 heading "MAX|CLT|BYTE|PER|BUF"
col AVG_SVR_BYTE_PER_BUF	format 999999 heading "AVG|SVR|BYTE|PER|BUF"
col AVG_CLT_BYTE_PER_BUF	format 999999 heading "AVG|CLT|BYTE|PER|BUF"

SELECT	name,
CUR_SVR_BYTE_PER_BUF,
CUR_CLT_BYTE_PER_BUF,
MAX_SVR_BYTE_PER_BUF,
MAX_CLT_BYTE_PER_BUF,
AVG_SVR_BYTE_PER_BUF,
MAX_CLT_BYTE_PER_BUF
FROM v$dispatcher_rate
/

SELECT	name,
CUR_BYTE_PER_BUF,
MAX_BYTE_PER_BUF,
AVG_BYTE_PER_BUF
FROM v$dispatcher_rate
/



