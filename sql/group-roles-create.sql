--
--
-- group-roles-create.sql
--    create a group of roles:
--        RL_app_READ
--        RL_app_EXEC
--        RL_app_FULL
--
-- Usage:
--    @group-roles-create APP
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--

SET SCAN ON
DEFINE _app=&&1

SET FEEDBACK ON
SET ECHO ON
SET VERIFY OFF

CREATE ROLE rl_&&_app._full ;
CREATE ROLE rl_&&_app._exec ;
CREATE ROLE rl_&&_app._read ;

SELECT role FROM dba_roles
 WHERE role LIKE UPPER('RL_&&_app%')
 ORDER BY 1
     ;

