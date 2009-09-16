--Setup the needed default date format, and language, for the session.
PROMPT Changing date language to 'AMERICAN', and
PROMPT the date format to 'DD-MON-RR'.
ALTER SESSION SET NLS_DATE_LANGUAGE='AMERICAN';
ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-RR';
PROMPT
PROMPT You may wish to reconnect after this script
PROMPT completes, as reconnecting will restore your
PROMPT date language and date format settings to
PROMPT their defaults.
PROMPT
PAUSE Press ENTER to continue...

-- Delete existing data from tables used in chapter 14.


delete from orders;
delete from customer;
delete from cust_order;


-- Insert new data relevant to chapter 14.


-- Insert data into orders


insert into orders 
(cust_nbr, region_id, salesperson_id, year, month, tot_orders, tot_sales)
select o.c_nbr, o.r_id, o.s_id, o.yr, o.mn, o.tot_o, o.tot_s
from
(select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 8118 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 13009 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 39906 tot_s from dual union all                                    
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 57411 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 30575 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 45417 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 72291 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 49118 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 10724 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 4391 tot_s from dual union all                                       
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 67010 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 51894 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 67139 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 14657 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 61640 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 33345 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 19737 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 41354 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 3965 tot_s from dual union all                                       
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 11460 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 22490 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 4097 tot_s from dual union all                                       
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 18717 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 34235 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 20514 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 70827 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 38100 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 66957 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 41519 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 33083 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 67274 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 42015 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 25604 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 21585 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 73791 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 32891 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 20659 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 34459 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 30923 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 1937 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 6757 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 3750 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 1326 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 12659 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 48901 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 33458 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 37879 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 10046 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 19778 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 34352 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 36120 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 3143 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 3030 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 36144 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 11029 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 36085 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 39232 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 38494 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 6315 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 19302 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 24264 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 29943 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 21862 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 2380 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 9282 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 32730 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 9111 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 38820 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 17633 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 4581 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 2431 tot_s from dual union all                                       
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 32999 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 4722 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 25281 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 21578 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 10508 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 9590 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 26239 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 6270 tot_s from dual union all                                      
select 7 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 32700 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 13732 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 15077 tot_s from dual union all                                     
select 7 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 21183 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 1949 tot_s from dual union all                                       
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 12509 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 29279 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 37496 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 20295 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 26285 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 28910 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 24404 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 18325 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 37805 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 26187 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 22282 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 29123 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 40117 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 18813 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 438 tot_s from dual union all                                        
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 39936 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 47721 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 13713 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 49552 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 2098 tot_s from dual union all                                       
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 35669 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 41140 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 19233 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 13978 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 14214 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 9300 tot_s from dual union all                                       
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 23214 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 23632 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 23027 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 899 tot_s from dual union all                                        
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 44651 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 38352 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 27262 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 17240 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 46076 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 9595 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 22778 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 43081 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 30547 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 21159 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 4993 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 1884 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 14474 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 41203 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 17496 tot_s from dual union all                                     
select 8 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 5458 tot_s from dual union all                                      
select 8 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 23846 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 38466 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 39124 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 33315 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 45994 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 27196 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 534 tot_s from dual union all                                        
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 13817 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 38628 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 126 tot_s from dual union all                                        
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 46577 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 40879 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 32670 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 29856 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 46789 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 6352 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 30079 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 38469 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 17651 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 2805 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 12121 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 36296 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 14703 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 6707 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 7821 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 26117 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 38427 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 41519 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 37491 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 44772 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 20000 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 31212 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 1086 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 1689 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 613 tot_s from dual union all                                        
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 3818 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 25769 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 49091 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 11883 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 20575 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 38371 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 45913 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 2959 tot_s from dual union all                                      
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 40003 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 46858 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 610 tot_s from dual union all                                       
select 9 c_nbr, 6 r_id, 6 s_id, 2001 yr, 12 mn, 1 tot_o, 13328 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 7 s_id, 2001 yr, 12 mn, 1 tot_o, 15972 tot_s from dual union all                                     
select 9 c_nbr, 6 r_id, 8 s_id, 2001 yr, 12 mn, 1 tot_o, 43908 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 46046 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 25677 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 24245 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 21691 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 29390 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 27847 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 42624 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 38946 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 25902 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 48235 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 6888 tot_s from dual union all                                      
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 9021 tot_s from dual union all                                      
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 46064 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 9202 tot_s from dual union all                                      
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 14141 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 25217 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 5 mn, 3 tot_o, 20592 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 5 mn, 3 tot_o, 13659 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 5 mn, 3 tot_o, 31842 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 5 mn, 3 tot_o, 45834 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 6 mn, 1 tot_o, 32074 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 6 mn, 1 tot_o, 329 tot_s from dual union all                                       
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 6 mn, 1 tot_o, 34891 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 6 mn, 1 tot_o, 19155 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 7 mn, 2 tot_o, 44012 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 7 mn, 2 tot_o, 13797 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 7 mn, 2 tot_o, 41860 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 7 mn, 2 tot_o, 12284 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 8 mn, 3 tot_o, 25222 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 8 mn, 3 tot_o, 35863 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 8 mn, 3 tot_o, 12687 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 8 mn, 3 tot_o, 45565 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 9 mn, 1 tot_o, 39348 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 9 mn, 1 tot_o, 43871 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 9 mn, 1 tot_o, 17415 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 9 mn, 1 tot_o, 11216 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 10 mn, 2 tot_o, 18751 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 10 mn, 2 tot_o, 2761 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 10 mn, 2 tot_o, 13434 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 10 mn, 2 tot_o, 994 tot_s from dual union all                                      
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 11 mn, 3 tot_o, 22250 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 6 s_id, 2001 yr, 11 mn, 3 tot_o, 29667 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 7 s_id, 2001 yr, 11 mn, 3 tot_o, 9849 tot_s from dual union all                                     
select 10 c_nbr, 6 r_id, 8 s_id, 2001 yr, 11 mn, 3 tot_o, 31440 tot_s from dual union all                                    
select 10 c_nbr, 6 r_id, 5 s_id, 2001 yr, 12 mn, 1 tot_o, 23917 tot_s from dual union all                                    
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 20863 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 2875 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 49763 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 18053 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 22182 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 11114 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 31234 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 29066 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 42391 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 22247 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 38541 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 2417 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 28269 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 24362 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 48825 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 2231 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 26107 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 42036 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 15520 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 47335 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 4928 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 41890 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 27627 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 32799 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 8809 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 44165 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 24777 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 30864 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 36886 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 1690 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 25878 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 8451 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 37432 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 29462 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 6817 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 43173 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 36052 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 23338 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 382 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 31963 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 41485 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 942 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 13721 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 867 tot_s from dual union all                                       
select 1 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 45300 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 10435 tot_s from dual union all                                     
select 1 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 2581 tot_s from dual union all                                      
select 1 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 13017 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 29993 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 4744 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 5042 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 40138 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 23357 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 7118 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 18495 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 46925 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 20443 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 1612 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 39409 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 17530 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 36205 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 31954 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 5983 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 3227 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 19382 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 18761 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 35841 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 37724 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 27623 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 25042 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 46864 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 41975 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 16380 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 47356 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 21605 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 36225 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 25728 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 3609 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 30780 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 37795 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 23786 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 46333 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 5594 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 16355 tot_s from dual union all                                      
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 17790 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 32224 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 21220 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 18721 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 45522 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 30370 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 955 tot_s from dual union all                                       
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 45660 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 28694 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 29766 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 41407 tot_s from dual union all                                     
select 2 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 15730 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 6895 tot_s from dual union all                                       
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 4477 tot_s from dual union all                                       
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 38005 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 46325 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 41205 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 22846 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 47639 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 12986 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 25503 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 43161 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 30512 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 24227 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 30108 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 38883 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 41875 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 33842 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 21348 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 10415 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 7287 tot_s from dual union all                                       
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 8182 tot_s from dual union all                                       
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 37579 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 41835 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 11104 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 11693 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 14989 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 10199 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 43212 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 25527 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 21873 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 38326 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 354 tot_s from dual union all                                        
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 17113 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 33718 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 10198 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 36699 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 11122 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 49856 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 9739 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 25815 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 21218 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 12898 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 1680 tot_s from dual union all                                      
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 18727 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 14280 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 44508 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 36496 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 24035 tot_s from dual union all                                     
select 3 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 772 tot_s from dual union all                                       
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 69830 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 27533 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 21116 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 15486 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 57999 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 10352 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 73760 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 27756 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 48480 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 6929 tot_s from dual union all                                       
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 67883 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 54719 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 63117 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 32093 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 33707 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 52218 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 40143 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 60920 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 20241 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 69519 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 33035 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 13361 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 20963 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 11474 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 26795 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 875 tot_s from dual union all                                        
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 68795 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 66764 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 72398 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 62186 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 56280 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 67550 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 52131 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 71195 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 13881 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 50910 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 12038 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 38127 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 13527 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 37802 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 31529 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 8036 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 1862 tot_s from dual union all                                      
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 51563 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 57383 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 44913 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 19506 tot_s from dual union all                                     
select 4 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 19595 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 1 mn, 2 tot_o, 37663 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 1 mn, 2 tot_o, 44376 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 1 mn, 2 tot_o, 15972 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 1 mn, 2 tot_o, 10066 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 2 mn, 3 tot_o, 49008 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 2 mn, 3 tot_o, 11412 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 2 mn, 3 tot_o, 33475 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 2 mn, 3 tot_o, 37817 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 3 mn, 1 tot_o, 7661 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 3 mn, 1 tot_o, 8384 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 3 mn, 1 tot_o, 28236 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 3 mn, 1 tot_o, 36198 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 4 mn, 2 tot_o, 28239 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 4 mn, 2 tot_o, 38251 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 4 mn, 2 tot_o, 68 tot_s from dual union all                                         
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 4 mn, 2 tot_o, 24165 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 5 mn, 3 tot_o, 33753 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 5 mn, 3 tot_o, 22088 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 5 mn, 3 tot_o, 6178 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 5 mn, 3 tot_o, 23505 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 6 mn, 1 tot_o, 22575 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 6 mn, 1 tot_o, 13145 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 6 mn, 1 tot_o, 16987 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 6 mn, 1 tot_o, 20855 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 7 mn, 2 tot_o, 19372 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 7 mn, 2 tot_o, 38136 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 7 mn, 2 tot_o, 4123 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 7 mn, 2 tot_o, 10366 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 8 mn, 3 tot_o, 5564 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 8 mn, 3 tot_o, 381 tot_s from dual union all                                        
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 8 mn, 3 tot_o, 5886 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 8 mn, 3 tot_o, 28928 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 9 mn, 1 tot_o, 31639 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 9 mn, 1 tot_o, 6489 tot_s from dual union all                                       
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 9 mn, 1 tot_o, 27978 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 9 mn, 1 tot_o, 20677 tot_s from dual union all                                      
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 10 mn, 2 tot_o, 46552 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 10 mn, 2 tot_o, 44397 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 10 mn, 2 tot_o, 19382 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 10 mn, 2 tot_o, 49505 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 11 mn, 3 tot_o, 37518 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 11 mn, 3 tot_o, 39107 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 11 mn, 3 tot_o, 24340 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 11 mn, 3 tot_o, 40333 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 1 s_id, 2001 yr, 12 mn, 1 tot_o, 37071 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 2 s_id, 2001 yr, 12 mn, 1 tot_o, 17512 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 3 s_id, 2001 yr, 12 mn, 1 tot_o, 22768 tot_s from dual union all                                     
select 5 c_nbr, 5 r_id, 4 s_id, 2001 yr, 12 mn, 1 tot_o, 21825 tot_s from dual union all                                     
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 1 mn, 2 tot_o, 14802 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 1 mn, 2 tot_o, 46230 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 1 mn, 2 tot_o, 23592 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 1 mn, 2 tot_o, 51350 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 2 mn, 3 tot_o, 50267 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 2 mn, 3 tot_o, 5091 tot_s from dual union all                                       
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 2 mn, 3 tot_o, 28211 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 2 mn, 3 tot_o, 12461 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 3 mn, 1 tot_o, 49256 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 3 mn, 1 tot_o, 57671 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 3 mn, 1 tot_o, 40347 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 3 mn, 1 tot_o, 41963 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 5 s_id, 2001 yr, 4 mn, 2 tot_o, 22208 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 6 s_id, 2001 yr, 4 mn, 2 tot_o, 6284 tot_s from dual union all                                       
select 6 c_nbr, 6 r_id, 7 s_id, 2001 yr, 4 mn, 2 tot_o, 60221 tot_s from dual union all                                      
select 6 c_nbr, 6 r_id, 8 s_id, 2001 yr, 4 mn, 2 tot_o, 55946 tot_s from dual) o;

insert into orders 
(cust_nbr, region_id, salesperson_id, year, month, tot_orders, tot_sales)
select o.c_nbr, o.r_id, o.s_id, o.yr, o.mn, o.tot_o, o.tot_s
from
(select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 5847 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 16686 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 31238 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 40836 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 32795 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 38221 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 16468 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 22554 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 35626 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 125 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 22235 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 16558 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 12631 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 23231 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 2552 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 6814 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 13049 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 38840 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 19139 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 23110 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 16623 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 32682 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 8826 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 13203 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 20448 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 27427 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 9569 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 39969 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 14245 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 31149 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 46148 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 15714 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 23374 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 8235 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 46252 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 16769 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 39636 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 44744 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 25329 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 42246 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 15128 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 19870 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 6030 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 20328 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 41585 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 9411 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 6106 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 13935 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 45998 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 9269 tot_s from dual union all                                
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 4896 tot_s from dual union all                                 
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 47771 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 24524 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 17274 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 18110 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 49696 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 17515 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 4929 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 45791 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 45147 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 42772 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 6280 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 38328 tot_s from dual union all                               
select 12 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 32402 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 31761 tot_s from dual union all                              
select 12 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 2582 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 6729 tot_s from dual union all                                 
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 24330 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 5084 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 3821 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 41165 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 48420 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 7628 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 48569 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 16841 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 1562 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 34505 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 29319 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 25866 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 10151 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 10098 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 12134 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 38856 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 36876 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 40473 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 48558 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 11187 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 20739 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 36565 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 34554 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 35318 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 44188 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 24427 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 37059 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 48050 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 43231 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 43886 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 13840 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 18060 tot_s from dual union all                                
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 13101 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 21009 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 20672 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 35757 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 14969 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 18760 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 38544 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 22735 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 36580 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 19996 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 18842 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 37052 tot_s from dual union all                               
select 13 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 48985 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 19393 tot_s from dual union all                              
select 13 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 41950 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 8138 tot_s from dual union all                                 
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 9971 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 28316 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 34374 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 57393 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 12408 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 59190 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 23172 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 62882 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 68912 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 65039 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 50226 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 52419 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 37374 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 16992 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 62543 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 57096 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 31625 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 26925 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 54732 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 32669 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 26903 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 36120 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 64077 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 39453 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 9182 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 61202 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 32460 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 7268 tot_s from dual union all                                 
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 30960 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 74861 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 21218 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 58583 tot_s from dual union all                                
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 48222 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 50066 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 60426 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 62457 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 10122 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 42308 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 24924 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 48666 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 56655 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 20678 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 38682 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 54816 tot_s from dual union all                               
select 14 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 28749 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 44624 tot_s from dual union all                              
select 14 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 23696 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 11100 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 28644 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 28731 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 32233 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 7649 tot_s from dual union all                                 
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 31285 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 25831 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 47475 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 27123 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 33080 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 32041 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 16510 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 47685 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 37045 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 47005 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 29464 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 1492 tot_s from dual union all                                 
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 16615 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 33397 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 12 tot_s from dual union all                                  
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 44933 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 37064 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 18287 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 6088 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 9910 tot_s from dual union all                                 
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 5137 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 37298 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 31725 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 10503 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 20929 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 8 mn, 3 tot_o, 31916 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 8 mn, 3 tot_o, 11396 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 9 mn, 1 tot_o, 41831 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 9 mn, 1 tot_o, 7065 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 9 mn, 1 tot_o, 22725 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 9 mn, 1 tot_o, 35896 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 10 mn, 2 tot_o, 25328 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 10 mn, 2 tot_o, 49140 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 10 mn, 2 tot_o, 9930 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 10 mn, 2 tot_o, 39579 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 11 mn, 3 tot_o, 27529 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 11 mn, 3 tot_o, 27933 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 11 mn, 3 tot_o, 373 tot_s from dual union all                                
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 11 mn, 3 tot_o, 20552 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 9 s_id, 2001 yr, 12 mn, 1 tot_o, 46300 tot_s from dual union all                               
select 15 c_nbr, 7 r_id, 10 s_id, 2001 yr, 12 mn, 1 tot_o, 45398 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 11 s_id, 2001 yr, 12 mn, 1 tot_o, 13749 tot_s from dual union all                              
select 15 c_nbr, 7 r_id, 12 s_id, 2001 yr, 12 mn, 1 tot_o, 42660 tot_s from dual union all                              
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 5 mn, 3 tot_o, 34491 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 5 mn, 3 tot_o, 37126 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 5 mn, 3 tot_o, 43638 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 5 mn, 3 tot_o, 11781 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 6 mn, 1 tot_o, 35364 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 6 mn, 1 tot_o, 27306 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 6 mn, 1 tot_o, 387 tot_s from dual union all                                 
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 6 mn, 1 tot_o, 33756 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 7 mn, 2 tot_o, 16728 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 7 mn, 2 tot_o, 48591 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 7 mn, 2 tot_o, 12204 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 7 mn, 2 tot_o, 34756 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 8 mn, 3 tot_o, 18151 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 8 mn, 3 tot_o, 4715 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 1 mn, 2 tot_o, 15898 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 1 mn, 2 tot_o, 18437 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 1 mn, 2 tot_o, 25574 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 1 mn, 2 tot_o, 6087 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 2 mn, 3 tot_o, 39597 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 2 mn, 3 tot_o, 25734 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 2 mn, 3 tot_o, 36465 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 2 mn, 3 tot_o, 36538 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 3 mn, 1 tot_o, 12876 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 3 mn, 1 tot_o, 39508 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 3 mn, 1 tot_o, 42623 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 3 mn, 1 tot_o, 28014 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 9 s_id, 2001 yr, 4 mn, 2 tot_o, 34614 tot_s from dual union all                                
select 11 c_nbr, 7 r_id, 10 s_id, 2001 yr, 4 mn, 2 tot_o, 21286 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 11 s_id, 2001 yr, 4 mn, 2 tot_o, 33217 tot_s from dual union all                               
select 11 c_nbr, 7 r_id, 12 s_id, 2001 yr, 4 mn, 2 tot_o, 38653 tot_s from dual) o;

commit; 


insert into orders
select CUST_NBR, REGION_ID, SALESPERSON_ID, 2000, MONTH, 2*TOT_ORDERS, 2*TOT_SALES
from orders;

commit;
 


-- Insert data into customer

insert into customer (cust_nbr, name, region_id, tot_orders, last_order_dt)
select c.c_nbr, c.c_nm, c.rgn, c.tot_ord, to_date(c.lst_ord, 'DD-MON-YYYY')
from
(select 1 c_nbr, 'Cooper Industries' c_nm, 5 rgn,  96 tot_ord, '15-JUN-2000' lst_ord from dual union all
select 2 c_nbr, 'Emblazon Corp.' c_nm, 5 rgn,  96 tot_ord, '27-JUN-2000' lst_ord from dual union all
select 3 c_nbr, 'Ditech Corp.' c_nm, 5 rgn,  96 tot_ord, '07-JUL-2000' lst_ord from dual union all
select 4 c_nbr, 'Flowtech Inc.' c_nm, 5 rgn,  96 tot_ord, '15-JUL-2000' lst_ord from dual union all
select 5 c_nbr, 'Gentech Industries' c_nm, 5 rgn,  96 tot_ord, '01-JUN-2000' lst_ord from dual union all
select 6 c_nbr, 'Spartan Industries' c_nm, 6 rgn,  96 tot_ord, '10-JUN-2000' lst_ord from dual union all
select 7 c_nbr, 'Wallace Labs' c_nm, 6 rgn,  101 tot_ord, '17-JUN-2000' lst_ord from dual union all
select 8 c_nbr, 'Zantech Inc.' c_nm, 6 rgn,  96 tot_ord, '22-JUN-2000' lst_ord from dual union all
select 9 c_nbr, 'Cardinal Technologies' c_nm, 6 rgn,  96 tot_ord, '25-JUN-2000' lst_ord from dual union all
select 10 c_nbr, 'Flowrite Corp.' c_nm, 6 rgn,  96 tot_ord, '01-JUN-2000' lst_ord from dual union all
select 11 c_nbr, 'Glaven Technologies' c_nm, 7 rgn,  96 tot_ord, '05-JUN-2000' lst_ord from dual union all
select 12 c_nbr, 'Johnson Labs' c_nm, 7 rgn,  96 tot_ord, '07-JUN-2000' lst_ord from dual union all
select 13 c_nbr, 'Kimball Corp.' c_nm, 7 rgn,  96 tot_ord, '07-JUN-2000' lst_ord from dual union all
select 14 c_nbr, 'Madden Industries' c_nm, 7 rgn,  101 tot_ord, '05-JUN-2000' lst_ord from dual union all
select 15 c_nbr, 'Turntech Inc.' c_nm, 7 rgn,  96 tot_ord, '01-JUN-2000' lst_ord from dual union all
select 16 c_nbr, 'Paulson Labs' c_nm, 8 rgn,  96 tot_ord, '31-MAY-2000' lst_ord from dual union all
select 17 c_nbr, 'Evans Supply Corp.' c_nm, 8 rgn,  96 tot_ord, '28-MAY-2000' lst_ord from dual union all
select 18 c_nbr, 'Spalding Medical Inc.' c_nm, 8 rgn,  96 tot_ord, '23-MAY-2000' lst_ord from dual union all
select 19 c_nbr, 'Kendall-Taylor Corp.' c_nm, 8 rgn,  96 tot_ord, '16-MAY-2000' lst_ord from dual union all
select 20 c_nbr, 'Malden Labs' c_nm, 8 rgn,  96 tot_ord, '01-JUN-2000' lst_ord from dual union all
select 21 c_nbr, 'Crimson Medical Inc.' c_nm, 9 rgn,  101 tot_ord, '26-MAY-2000' lst_ord from dual union all
select 22 c_nbr, 'Nichols Industries' c_nm, 9 rgn,  96 tot_ord, '18-MAY-2000' lst_ord from dual union all
select 23 c_nbr, 'Owens-Baxter Corp.' c_nm, 9 rgn,  96 tot_ord, '08-MAY-2000' lst_ord from dual union all
select 24 c_nbr, 'Jackson Medical Inc.' c_nm, 9 rgn, 96 tot_ord, '26-APR-2000' lst_ord from dual union all
select 25 c_nbr, 'Worcester Technologies' c_nm, 9 rgn,  96 tot_ord, '01-JUN-2000' lst_ord from dual union all
select 26 c_nbr, 'Alpha Technologies' c_nm, 10 rgn,  96 tot_ord, '21-MAY-2000' lst_ord from dual union all
select 27 c_nbr, 'Phillips Labs' c_nm, 10 rgn,  96 tot_ord, '08-MAY-2000' lst_ord from dual union all
select 28 c_nbr, 'Jaztech Corp.' c_nm, 10 rgn,  101 tot_ord, '23-APR-2000' lst_ord from dual union all
select 29 c_nbr, 'Madden-Taylor Inc.' c_nm, 10 rgn,  96 tot_ord, '06-APR-2000' lst_ord from dual union all
select 30 c_nbr, 'Wallace Industries' c_nm, 10 rgn,  96 tot_ord, '01-JUN-2000' lst_ord from dual) c;

commit;


-- Insert data into cust_order

insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1001,1,7354,99,'22-JUL-01','23-JUL-01',null,null,'DELIVERED');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1000,1,7354,null,'19-JUL-01','24-JUL-01','21-JUL-01',null,'CANCELLED');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1002,5,7368,null,'12-JUL-01','25-JUL-01','14-JUL-01',null,'CANCELLED');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1003,4,7654,56,'16-JUL-01','26-JUL-01',null,null,'DELIVERED');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1004,4,7654,34,'18-JUL-01','27-JUL-01',null,null,'PENDING');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1005,8,7654,99,'22-JUL-01','24-JUL-01',null,null,'DELIVERED');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1006,1,7354,null,'22-JUL-01','28-JUL-01','24-JUL-01',null,'CANCELLED');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1007,5,7368,25,'20-JUL-01','22-JUL-01',null,null,'PENDING');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1008,5,7368,25,'21-JUL-01','23-JUL-01',null,null,'PENDING');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1009,1,7354,56,'18-JUL-01','22-JUL-01',null,null,'DELIVERED');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1012,1,7354,99,'22-JUL-01','23-JUL-01',null,null,'DELIVERED');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1011,1,7354,null,'19-JUL-01','24-JUL-01','21-JUL-01',null,'CANCELLED');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1015,5,7368,null,'12-JUL-01','25-JUL-01','14-JUL-01',null,'CANCELLED');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1017,4,7654,56,'16-JUL-01','26-JUL-01',null,null,'DELIVERED');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1019,4,7654,34,'18-JUL-01','27-JUL-01',null,null,'PENDING');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1021,8,7654,99,'22-JUL-01','24-JUL-01',null,null,'DELIVERED');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1023,1,7354,null,'22-JUL-01','28-JUL-01','24-JUL-01',null,'CANCELLED');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1025,5,7368,25,'20-JUL-01','22-JUL-01',null,null,'PENDING');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1027,5,7368,25,'21-JUL-01','23-JUL-01',null,null,'PENDING');
insert into cust_order 
(ORDER_NBR,CUST_NBR,SALES_EMP_ID,SALE_PRICE,ORDER_DT,EXPECTED_SHIP_DT,CANCELLED_DT,SHIP_DT,STATUS)
values
(1029,1,7354,56,'18-JUL-01','22-JUL-01',null,null,'DELIVERED');



commit;



