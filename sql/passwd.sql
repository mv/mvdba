--
-- passwd.sql
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

select username
     , password
  from dba_users
 where 1=1
 order by username
     ;


