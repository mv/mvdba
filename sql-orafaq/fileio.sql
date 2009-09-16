Set TrimSpool On
Set Line 142
Set Pages 57
Set NewPage 0
Set FeedBack Off
Set Verify Off
Set Term Off
TTitle Off
BTitle Off
Clear Breaks
Break On Tablespace_Name
Column TableSpace_Name For A12 Head "Tablespace"
Column Name             For A45         Head "File Name"
Column Total            For 999,999,990 Head "Total"
Column Phyrds           For 999,999,990 Head "Physical|Reads "
Column Phywrts          For 999,999,990 Head "Physical| Writes "
Column Phyblkrd         For 999,999,990 Head "Physical |Block Reads"
Column Phyblkwrt        For 999,999,990 Head "Physical |Block Writes"
Column Avg_Rd_Time      For 90.9999999  Head "Average |Read Time|Per Block"
Column Avg_Wrt_Time     For 90.9999999  Head "Average |Write Time|Per Block"
Column Instance         New_Value _Instance NoPrint
Column Today            New_Value _Date NoPrint

select Global_Name Instance, To_Char(SysDate, 'FXDay DD, YYYY HH:MI') Today
from Global_Name;

TTitle On
TTitle Left 'Date Run: ' _Date Skip 1-
Center 'Data File I/O'  Skip 1 -
Center 'Instance Name: ' _Instance Skip 1

select C.TableSpace_Name, B.Name, A.Phyblkrd +
A.Phyblkwrt Total, A.Phyrds, A.Phywrts,
A.Phyblkrd, A.Phyblkwrt
from V$FileStat A, V$DataFile B, Sys.DBA_Data_Files C
where B.File# = A.File#
and B.File# = C.File_Id
order by TableSpace_Name, A.File#
/

