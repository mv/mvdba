REM  Search for third party grants

Rem
rem  third_party_grants.sql
rem
rem  This query searches for grants made by users
rem  other than the table owners.  These grants cannot
rem  be exported via User exports.
rem
break on Grantor skip 1 on Owner on Table_Name
select
      Grantor,          /*Account that made the grant*/
      Owner,            /*Account that owns the table*/
      Table_Name,       /*Name of the table*/
      Grantee,          /*Account granted access*/
      Privilege,        /*Privilege granted*/
      Grantable         /*Granted with admin option?*/
from DBA_TAB_PRIVS
where Grantor ! = Owner
order by Grantor, Owner, Table_Name, Grantee, Privilege

spool third_parts_privs.lst
/
spool off
