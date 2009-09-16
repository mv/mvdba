Column TableSpace_Name  For A12            Head "Tablespace"
Column Total            For 9,999,999,990  Head "Total"
Column Phyrds           For 9,999,999,990  Head "Physical|Reads "
Column Phywrts          For 9,999,999,990  Head "Physical| Writes "
Column Phyblkrd         For 9,999,999,990  Head "Physical |Block Reads"
Column Phyblkwrt        For 9,999,999,990  Head "Physical |Block Writes"
Column Avg_Rd_Time      For 9,999,990.9999 Head "Average |Read Time|Per Block"
Column Avg_Wrt_Time     For 9,999,990.9999 Head "Average |Write Time|Per Block"
Clear Breaks
Break on Disk Skip 1
Compute Sum Of Total     On Disk
Compute Sum Of Phyrds    On Disk
Compute Sum Of Phywrts   On Disk
Compute Sum Of Phyblkrd  On Disk
Compute Sum Of Phyblkwrt On Disk

TTitle Left   'Date Run: ' _Date Skip 1-
       Center 'Disk I/O'   Skip 1 -
       Center 'Instance Name: ' _Instance Skip 2

select SubStr(B.Name, 1, 13) Disk
     , C.TableSpace_Name
     , A.Phyblkrd + A.Phyblkwrt Total
     , A.Phyrds
     , A.Phywrts
     , A.Phyblkrd
     , A.Phyblkwrt
     ,((A.ReadTim /Decode(A.Phyrds
                          ,0,1
                          ,A.Phyblkrd)
                          ) /100) Avg_Rd_Time
     ,((A.WriteTim/Decode(A.PhyWrts
                         ,0,1
                         ,A.PhyblkWrt)
                         ) /100) Avg_Wrt_Time
  from V$FileStat A
     , V$DataFile B
     , Sys.DBA_Data_Files C
 where B.File# = A.File#
   and B.File# = C.File_Id
 order by Disk,C.Tablespace_Name, A.File#
/

