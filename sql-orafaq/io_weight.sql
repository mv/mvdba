REM  Generate I/O Weightings

REM Note: The script assumes that the devices are 
REM  consistently named and that the device name is 
REM  five characters long (see the SUBSTR of the 
REM  DF.Name column). If your device names are longer 
REM  than that, you will need to alter the script to 
REM  meet your specifications.
REM
set pagesize 60 linesize 80 newpage 0 feedback off
ttitle skip center "Database File IO Weights" skip center -
"ordered by Drive" skip 2
column Total_IO format 999999999
column Weight format 999.99
column file_name format A40
break on Drive skip 2
compute sum of Weight on Drive
select
substr(DF.Name, 1,5) Drive,
DF.Name File_Name,
FS.Phyblkrd+FS.Phyblkwrt Total_IO,
100*(FS.Phyblkrd+FS.Phyblkwrt)/MaxIO Weight
from V$FILESTAT FS, V$DATAFILE DF,
  (select MAX(Phyblkrd+Phyblkwrt) MaxIO
    from V$FILESTAT)
where DF.File# = FS.File#
order by Drive, Weight desc

spool io_weights
/
spool off


