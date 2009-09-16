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

-- Delete existing data from tables used in chapter 7.


delete from customer;
delete from cust_order;


-- Insert new data relevant to chapter 7.


-- Insert data into customer

insert into customer (cust_nbr, name, region_id, tot_orders, last_order_dt)
select c.c_nbr, c.c_nm, c.rgn, c.tot_ord, to_date(c.lst_ord, 'DD-MON-RR')
from
(select 1 c_nbr, 'Cooper Industries' c_nm, 5 rgn,  96 tot_ord, '15-JUN-00' lst_ord from dual union all
select 2 c_nbr, 'Emblazon Corp.' c_nm, 5 rgn,  96 tot_ord, '27-JUN-00' lst_ord from dual union all
select 3 c_nbr, 'Ditech Corp.' c_nm, 5 rgn,  96 tot_ord, '07-JUL-00' lst_ord from dual union all
select 4 c_nbr, 'Flowtech Inc.' c_nm, 5 rgn,  96 tot_ord, '15-JUL-00' lst_ord from dual union all
select 5 c_nbr, 'Gentech Industries' c_nm, 5 rgn,  96 tot_ord, '01-JUN-00' lst_ord from dual union all
select 6 c_nbr, 'Spartan Industries' c_nm, 6 rgn,  96 tot_ord, '10-JUN-00' lst_ord from dual union all
select 7 c_nbr, 'Wallace Labs' c_nm, 6 rgn,  101 tot_ord, '17-JUN-00' lst_ord from dual union all
select 8 c_nbr, 'Zantech Inc.' c_nm, 6 rgn,  96 tot_ord, '22-JUN-00' lst_ord from dual union all
select 9 c_nbr, 'Cardinal Technologies' c_nm, 6 rgn,  96 tot_ord, '25-JUN-00' lst_ord from dual union all
select 10 c_nbr, 'Flowrite Corp.' c_nm, 6 rgn,  96 tot_ord, '01-JUN-00' lst_ord from dual union all
select 11 c_nbr, 'Glaven Technologies' c_nm, 7 rgn,  96 tot_ord, '05-JUN-00' lst_ord from dual union all
select 12 c_nbr, 'Johnson Labs' c_nm, 7 rgn,  96 tot_ord, '07-JUN-00' lst_ord from dual union all
select 13 c_nbr, 'Kimball Corp.' c_nm, 7 rgn,  96 tot_ord, '07-JUN-00' lst_ord from dual union all
select 14 c_nbr, 'Madden Industries' c_nm, 7 rgn,  101 tot_ord, '05-JUN-00' lst_ord from dual union all
select 15 c_nbr, 'Turntech Inc.' c_nm, 7 rgn,  96 tot_ord, '01-JUN-00' lst_ord from dual union all
select 16 c_nbr, 'Paulson Labs' c_nm, 8 rgn,  96 tot_ord, '31-MAY-00' lst_ord from dual union all
select 17 c_nbr, 'Evans Supply Corp.' c_nm, 8 rgn,  96 tot_ord, '28-MAY-00' lst_ord from dual union all
select 18 c_nbr, 'Spalding Medical Inc.' c_nm, 8 rgn,  96 tot_ord, '23-MAY-00' lst_ord from dual union all
select 19 c_nbr, 'Kendall-Taylor Corp.' c_nm, 8 rgn,  96 tot_ord, '16-MAY-00' lst_ord from dual union all
select 20 c_nbr, 'Malden Labs' c_nm, 8 rgn,  96 tot_ord, '01-JUN-00' lst_ord from dual union all
select 21 c_nbr, 'Crimson Medical Inc.' c_nm, 9 rgn,  101 tot_ord, '26-MAY-00' lst_ord from dual union all
select 22 c_nbr, 'Nichols Industries' c_nm, 9 rgn,  96 tot_ord, '18-MAY-00' lst_ord from dual union all
select 23 c_nbr, 'Owens-Baxter Corp.' c_nm, 9 rgn,  96 tot_ord, '08-MAY-00' lst_ord from dual union all
select 24 c_nbr, 'Jackson Medical Inc.' c_nm, 9 rgn, 96 tot_ord, '26-APR-00' lst_ord from dual union all
select 25 c_nbr, 'Worcester Technologies' c_nm, 9 rgn,  96 tot_ord, '01-JUN-00' lst_ord from dual union all
select 26 c_nbr, 'Alpha Technologies' c_nm, 10 rgn,  96 tot_ord, '21-MAY-00' lst_ord from dual union all
select 27 c_nbr, 'Phillips Labs' c_nm, 10 rgn,  96 tot_ord, '08-MAY-00' lst_ord from dual union all
select 28 c_nbr, 'Jaztech Corp.' c_nm, 10 rgn,  101 tot_ord, '23-APR-00' lst_ord from dual union all
select 29 c_nbr, 'Madden-Taylor Inc.' c_nm, 10 rgn,  96 tot_ord, '06-APR-00' lst_ord from dual union all
select 30 c_nbr, 'Wallace Industries' c_nm, 10 rgn,  96 tot_ord, '01-JUN-00' lst_ord from dual) c;

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


