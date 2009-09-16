
set heading on
set pagesize 100
set linesize 400
set feedback off

column text format a200

SELECT owner
     , name
     , type
     , line
     , text
  FROM dba_source
 WHERE owner like 'IRPT%'
 ORDER by owner,type,name,line

spool plsql.txt

/

spool off

