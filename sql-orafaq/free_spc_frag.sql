REM  Measuring free space fragmentation

rem
rem  file: fsfi.sql
rem
rem  This script measures the fragmentation of free space
rem  in all of the tablespaces in a database and scores them
rem  according to an arbitrary index for comparison.
rem
set newpage 0 pagesize 60
column fsfi format 999.99
select
      Tablespace_Name,
      SQRT(MAX(Blocks)/SUM(Blocks))*
      (100/SQRT(SQRT(COUNT(Blocks)))) Fsfi
from DBA_FREE_SPACE
group by
      Tablespace_Name
order by 1

spool fsfi.lst
/
spool off

