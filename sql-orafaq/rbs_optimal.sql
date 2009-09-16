REM  Determining the optimal setting for rollback segments;

select N.Name,         /* rollback segment name */
       S.OptSize       /* rollback segment OPTIMAL size */
from V$ROLLNAME N, V$ROLLSTAT S
where N.USN=S.USN;

