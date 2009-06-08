
-- all SQL*Plus current settings
STORE SET /tmp/afiedt.restore.buf REPLACE

SET VERIFY OFF
SET LINESIZE 100
DESC &&1

-- restore
@ /tmp/afiedt.restore.buf

