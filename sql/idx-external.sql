REM  Search for third party indexes

rem
rem  third_party_indexes.sql
rem
rem  This query searches for indexes created by
rem  anyone other than the table owner.
rem
select
      Owner,                /*Owner of the index*/
      Index_Name,           /*Name of the index*/
      Table_Owner,          /*Owner of the table*/
      Table_Name            /*Name of the indexed table*/
from DBA_INDEXES
where Owner != Table_Owner

spool third_party_indexes.lst
/
spool off

