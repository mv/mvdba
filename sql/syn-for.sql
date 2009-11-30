--
--
-- syn-for
--    create local synonyms for OWNER.object
--
-- Usage:
--    sqlplus dba/pass@bd @ syn-for USER OWNER
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-06
--

SET PAGESIZE 0
SET LINESIZE 200
SET FEEDBACK OFF
SET VERIFY OFF
SET TIME OFF
SET TIMING OFF

PROMPT
PROMPT CREATE OR REPLACE SYNONYM _user.obj_name FOR _owner.obj_name ;
PROMPT
PROMPT Param1: synonym will be created into _user:
DEFINE  _user=&1
PROMPT
PROMPT Param2: for _owner:
DEFINE _owner=&2

-- owner exists?
WHENEVER SQLERROR EXIT
    SELECT 'User: '||username FROM all_users WHERE username = upper('&&_owner') ;
    SELECT 'User: '||username FROM all_users WHERE username = upper('&&_user')  ;
/

WHENEVER SQLERROR CONTINUE

spool /tmp/s.sql

prompt SET ECHO ON
prompt SET FEEDBACK ON

SELECT 'create or replace synonym '||RPAD( '&&_user..'||object_name,50,' ')||' for &&_owner..'||RPAD(object_name,31,' ')
     ||'-- '||object_type||' ;'
  FROM all_objects
 WHERE owner = upper('&&_owner')
   AND object_type IN ('TABLE','VIEW','SEQUENCE','FUNCTION','PROCEDURE','PACKAGE','TYPE')
 ORDER BY object_type,object_name
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

spool off

@/tmp/s.sql

undef _user
undef _owner

