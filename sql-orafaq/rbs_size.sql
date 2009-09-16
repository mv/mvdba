REM  Current rollback segment size

select
   N.Name,                      /* rollback segment name */
   S.RsSize                     /* rollback segment size */
from V$ROLLNAME N, V$ROLLSTAT S
where N.USN=S.USN;
