--
--
-- group-roles-grant.sql
--    grant a group of roles:
--        RL_app_READ
--        RL_app_EXEC
--        RL_app_FULL
--
-- Usage:
--    @group-roles-grant APP GRANTEE
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-08
--

SET SCAN ON
DEFINE _app=&&1
DEFINE _grantee=&&2

SET FEEDBACK ON
SET ECHO ON
SET VERIFY OFF

GRANT rl_&&_app._full TO &&_grantee ;
----  rl_&&_app._exec TO &&_grantee ;
----  rl_&&_app._read TO &&_grantee ;

SELECT *
  FROM dba_role_privs
 WHERE granted_role LIKE UPPER('RL_&&_app%')
   AND grantee = UPPER('&&_grantee')
 ORDER BY 1
     ;

