REM 
REM This short script lists objects which appear in both the 
REM SYS and SYSTEM schema's. It may be used to locate items which have 
REM been incorrectly created in the SYSTEM account. 
REM NOTE that not all items listed are erroneous - some may correctly 
REM      have instances in both schemas
REM
REM This version of the script is for ORACLE8.0 and higher
REM For Oracle7 the 'TYPE#' entries must be replaced with just 'TYPE'
REM
REM The script should be run connected as SYS 
REM
select 
 substr(decode(system.type#, 
                  1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                  4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
                  7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                 11, 'PACKAGE BODY', 12, 'TRIGGER',
                 13, 'TYPE', 14, 'TYPE BODY',
                 19, 'TABLE PARTITION', 20, 'INDEX PARTITION',
                 22, 'LIBRARY', 23, 'DIRECTORY', 
                 'Type='||system.type#)
         ,1,15) "Type",
 system.name,
 decode(sys.status, 0, 'N/A', 1, 'VALID', 'INVALID') "Sys",
 decode(system.status, 0, 'N/A', 1, 'VALID', 'INVALID') "System"
from user$ u, obj$ system, obj$ sys
where u.name='SYSTEM'
  and u.user#=system.owner#
  and system.type#=sys.type#
  and system.name=sys.name
  and sys.owner#=0
  and system.type#!=10 /* N/A objects */
order by 1,2
;
REM 