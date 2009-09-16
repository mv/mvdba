REM  Map users to tablespaces

rem
rem   user_tablespace_maps.sql
rem
rem  This script maps user objects to tablespaces.
rem
set pagesize 60
break on Owner on Tablespace_Name
column Objects format A20
select
      Owner,
      Tablespace_Name,
      COUNT(*)||' tables' Objects
 from DBA_TABLES
where Owner <> 'SYS'
group by
      Owner,
      Tablespace_Name
union
select
      Owner,
      Tablespace_Name,
      COUNT(*)||' indexes' Objects
 from DBA_INDEXES
where Owner <> 'SYS'
group by
      Owner,
      Tablespace_Name

spool use2tbspc.lst
/
spool off

