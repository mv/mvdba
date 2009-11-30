--
--
-- AbrilDigital
--    create local synonyms from [another] OWNER's schema
--
-- Usage:
--    sqlplus CONNECT_USER/pass@bd @ syn-from-user.sql OWNER
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-06
--

SET PAGESIZE 0
SET LINESIZE 200
SET FEEDBACK OFF
SET VERIFY OFF
SET TIME    OFF
SET TIMING  OFF

SET SCAN ON
DEFINE _user=&&1

-- owner exists?
WHENEVER SQLERROR EXIT
    SELECT 'User: '||username FROM all_users WHERE username = upper('&&_user')
/

WHENEVER SQLERROR CONTINUE

prompt SET ECHO ON
prompt SET FEEDBACK ON

SELECT 'create or replace synonym '||RPAD(object_name,31,' ')||' for &&_user..'||RPAD(object_name,31,' ')||' ;'
  FROM all_objects
 WHERE owner = upper('&&_user')
 ORDER BY object_type,1
/

SELECT CHR(10)||'-- removing invalids'||chr(10)||'--' from dual;

SELECT 'drop synonym '||synonym_name||'; -- '||RPAD(obj.object_type,31,' ')||obj.owner||'.'||obj.object_name
  FROM user_synonyms syn
     , all_objects   obj
 WHERE syn.table_owner = obj.owner (+)
   AND syn.table_name  = obj.object_name (+)
   AND obj.object_name IS NULL
 ORDER BY syn.synonym_name
        , obj.object_type
        , obj.object_name
     ;

SET PAGESIZE 200
SET FEEDBACK ON


