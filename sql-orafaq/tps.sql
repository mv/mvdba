-- http://searchdatabase.techtarget.com/tip/0,289483,sid13_gci852256,00.html
--
-- Determining transactions per second
--
-- Cory Brooks
-- 25 Sep 2002, Rating 4.82 (out of 5)
--
-- When asked how many transactions per second were happening on each system,
-- I realized that a quick approximation could be derived from the number of
-- SCN changes per second as recorded in the logs, so I wrote the following code.
--
-- Management asked for a rough cut on the number of transactions per second
-- because that's how vendors describe their systems. We were looking to replace
-- our systems with newer, larger machines. Rather than just calculate an overall
-- average, I realized that determining utilization by hour would let us identify
-- peak loads so that the new machine could be sized to handle the peaks and not
-- just the daily average. Subsequently, we use it to monitor system utilization:
-- We watch for changes in the level of system utilization and can tell if an user
-- performance concern is due to increased system load.
--
-- I've run it on Oracle 8 & 9. It does not work on 7.
--

set pages 60
set lines 132
set term off
ttitle off
column dbname       new_value  dbname
column time_stamp   new_value time_stamp
column timestamp_np noprint
column year_np      noprint
column month_np     noprint
column mon          format a3
column day          format a2

set verify off
select name dbname, substr(to_char(sysdate,'YYYY-Mon-DD HH24:MI:SS'),1,20) time_stamp
   from v$database;
ttitle left "Transactions (SCNs) per second" center "&dbname" right "&time_stamp"

set linesize 180
set term on
column tps00 format 99999 head "00"
column tps01 format 99999 head "01"
column tps02 format 99999 head "02"
column tps03 format 99999 head "03"
column tps04 format 99999 head "04"
column tps05 format 99999 head "05"
column tps06 format 99999 head "06"
column tps07 format 99999 head "07"
column tps08 format 99999 head "08"
column tps09 format 99999 head "09"
column tps10 format 99999 head "10"
column tps11 format 99999 head "11"
column tps12 format 99999 head "12"
column tps13 format 99999 head "13"
column tps14 format 99999 head "14"
column tps15 format 99999 head "15"
column tps16 format 99999 head "16"
column tps17 format 99999 head "17"
column tps18 format 99999 head "18"
column tps19 format 99999 head "19"
column tps20 format 99999 head "20"
column tps21 format 99999 head "21"
column tps22 format 99999 head "22"
column tps23 format 99999 head "23"
select * from
(
select substr(year_np,1,8)  timestamp_np,
       substr(year_np,5,2) Mon, substr(year_np,7,2) Day,
       sum(decode(substr(year_np,9,2),'00',1,0) * tps)   tps00,
       sum(decode(substr(year_np,9,2),'01',1,0) * tps)   tps01,
       sum(decode(substr(year_np,9,3),'02',1,0) * tps)   tps02,
       sum(decode(substr(year_np,9,2),'03',1,0) * tps)   tps03,
       sum(decode(substr(year_np,9,2),'04',1,0) * tps)   tps04,
       sum(decode(substr(year_np,9,3),'05',1,0) * tps)   tps05,
       sum(decode(substr(year_np,9,2),'06',1,0) * tps)   tps06,
       sum(decode(substr(year_np,9,2),'07',1,0) * tps)   tps07,
       sum(decode(substr(year_np,9,3),'08',1,0) * tps)   tps08,
       sum(decode(substr(year_np,9,2),'09',1,0) * tps)   tps09,
       sum(decode(substr(year_np,9,2),'11',1,0) * tps)   tps10,
       sum(decode(substr(year_np,9,3),'11',1,0) * tps)   tps11,
       sum(decode(substr(year_np,9,3),'12',1,0) * tps)   tps12,
       sum(decode(substr(year_np,9,2),'13',1,0) * tps)   tps13,
       sum(decode(substr(year_np,9,2),'14',1,0) * tps)   tps14,
       sum(decode(substr(year_np,9,3),'15',1,0) * tps)   tps15,
       sum(decode(substr(year_np,9,2),'16',1,0) * tps)   tps16,
       sum(decode(substr(year_np,9,2),'17',1,0) * tps)   tps17,
       sum(decode(substr(year_np,9,3),'18',1,0) * tps)   tps18,
       sum(decode(substr(year_np,9,2),'19',1,0) * tps)   tps19,
       sum(decode(substr(year_np,9,2),'20',1,0) * tps)   tps20,
       sum(decode(substr(year_np,9,3),'21',1,0) * tps)   tps21,
       sum(decode(substr(year_np,9,3),'22',1,0) * tps)   tps22,
       sum(decode(substr(year_np,9,2),'23',1,0) * tps)   tps23
  from (select to_char(first_time,'YYYYMMDDHH24') year_np,
               (max(next_change#) - min(first_change#))/(60 * 60) tps
          from v$log_history
         group by to_char(first_time,'YYYYMMDDHH24')
        )
group by substr(year_np,1,8), substr(year_np,5,2), substr(year_np,7,2)
)
order by timestamp_np
/

