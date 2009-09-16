Set TrimSpool On
Set NewPage 0
Set Pages 57
Set Line 132
Set FeedBack Off
Set Verify Off
Set Term Off
TTitle Off
BTitle Off
Clear Breaks
Column Event            For A40 Heading "Wait Event"
Column Total_Waits      For 999,999,990 Head "Total Number| Of Waits "
Column Total_Timeouts   For 999,999,990 Head "Total Number|Of TimeOuts"
Column Tot_Time         For 999,999,990 Head "Total Time|Waited "
Column Avg_Time         For 99,990.999 Head "Average Time|Per Wait "
Column Instance         New_Value _Instance NoPrint
Column Today            New_Value _Date NoPrint

select Global_Name Instance
     , To_Char(SysDate,'FXDay DD, YYYY HH:MI') Today
  from Global_Name;

select event
     , total_waits
     , total_timeouts
     , (time_waited / 100) tot_time
     , (average_wait / 100) Avg_time
  from v$system_event
 order by total_waits desc
/

