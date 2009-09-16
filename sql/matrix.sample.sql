rem -----------------------------------------------------------------------
rem UPDATED VERSION
rem Filename:   matrix.sql
rem Purpose:    Example of a CROSS MATRIX report implemented using
rem             standard SQL.
rem Date:       12-Feb-2000
rem Author:     Frank Naude, Oracle FAQ
rem
rem Updated By  Mahesh Pednekar. (bunty609@hotmail.com)
rem Description Removed the Main query because the sub query itself
rem             will full fill the requirement.
rem -----------------------------------------------------------------------

SELECT job,
                sum(decode(deptno,10,sal)) DEPT10,
                sum(decode(deptno,20,sal)) DEPT20,
                sum(decode(deptno,30,sal)) DEPT30,
                sum(decode(deptno,40,sal)) DEPT40
           FROM scott.emp
       GROUP BY job
/

-- Sample output:
--
-- JOB           DEPT10     DEPT20     DEPT30     DEPT40
-- --------- ---------- ---------- ---------- ----------
-- ANALYST                    6000
-- CLERK           1300       1900        950
-- MANAGER         2450       2975       2850
-- PRESIDENT       5000
-- SALESMAN                              5600
--

