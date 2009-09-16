REM  Map tablespaces to users

rem
rem   user_tablespace_maps.sql
rem
rem  This script maps user objects to tablespaces.
rem
set pagesize 60
break on Tablespace_Name on Owner
column Objects format A20
select
      Tablespace_Name,
      Owner,
      COUNT(*)||' tables' Objects
 from DBA_TABLES
where Owner <> 'SYS'
group by
      Tablespace_Name,
      Owner
union
select
      Tablespace_Name,
      Owner,
      COUNT(*)||' indexes' Objects
 from DBA_INDEXES
where Owner <> 'SYS'
group by
      Tablespace_Name,
      Owner

spool tbspc2users.lst
/
spool off


