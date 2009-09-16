Set TrimSpool On
Set Line 132
Set Pages 57
Set NewPage 0
Set FeedBack Off
Set Verify Off
Set Term Off
TTitle Off
BTitle Off

select Global_Name Instance, To_Char
(SysDate, 'FXDay DD, YYYY HH:MI') Today
from Global_Name;

select ((A.Count / (B.Value + C.Value)) * 100) Pct
from V$WaitStat A, V$SysStat B, V$SysStat C
where A.Class = 'free list'
and B.Statistic# = (select Statistic#
from V$StatName
where Name = 'db block gets')
and C.Statistic# = (select Statistic#
from V$StatName
where Name = 'consistent gets')
/

