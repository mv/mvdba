--
-- users.sql
--     simple user list
--
-- Marcus Vinicius Ferreira                     ferreira.mv[ at ]gmail.com
-- 2009/Jun
--

SET TRIMSPOOL ON
SET TRIMOUT   ON

COLUMN username             FORMAT a20
COLUMN password             FORMAT a16
COLUMN account_status       FORMAT a16
COLUMN default_tbspc        FORMAT a15
COLUMN temp_tbspc           FORMAT a15
COLUMN default_tablespace   FORMAT a15
COLUMN temporary_tablespace FORMAT a15
COLUMN external_name        FORMAT a15

ALTER SESSION SET NLS_DATE_FORMAT='yyyy-mm-dd_hh24:mi:ss';

select username
     , default_tablespace   default_tbspc
     , temporary_tablespace temp_tbspc
     , password
     , replace(account_status, ' ','_') as account_status
     , created
     , lock_date
     , expiry_date
     , external_name
  from dba_users
 where 1=1
 order by username
     ;


