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

-- Delete existing data from tables used in chapter 8.


delete from employee;
delete from assembly;


-- Insert new data relevant to chapter 8.


-- Insert data into employee

insert into employee 
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
values
(7369,'JOHN','SMITH',20,7902,800,'17-DEC-80',667);
insert into employee 
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
values
(7499,'KEVIN','ALLEN',30,7698,1600,'20-FEB-81',670);
insert into employee 
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
values
(7521,'CYNTHIA','WARD',30,7698,1250,'22-FEB-81',670);
insert into employee 
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
values
(7566,'TERRY','JONES',20,7839,2000,'02-APR-81',671);
insert into employee 
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
values
(7654,'KENNETH','MARTIN',30,7698,1250,'28-SEP-81',670);
insert into employee 
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
values
(7698,'MARION','BLAKE',30,7839,2850,'01-MAY-80',671);
insert into employee 
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
values
(7782,'CAROL','CLARK',10,7839,2450,'09-JUN-81',671);
insert into employee 
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
values
(7788,'DONALD','SCOTT',20,7566,3000,'19-APR-87',669);
insert into employee 
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
values
(7839,'FRANCIS','KING',10, null,5000,'17-NOV-81',672);
insert into employee 
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
values
(7844,'MARY','TURNER',30,7698,1500,'08-SEP-81',670);
insert into employee 
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
values
(7876,'DIANE','ADAMS',20,7788,1100,'23-MAY-87',667);
insert into employee 
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
values
(7900,'FRED','JAMES',30,7698,950,'03-DEC-81',667);
insert into employee 
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
values
(7902,'JENNIFER','FORD',20,7566,3000,'03-DEC-81',669);
insert into employee 
(EMP_ID,FNAME,LNAME,DEPT_ID,MANAGER_EMP_ID,SALARY,HIRE_DATE,JOB_ID)
values
(7934,'BARBARA','MILLER',10,7782,1300,'23-JAN-82',667);

commit;



-- Insert data into ASSEMBLY

insert into assembly 
(ASSEMBLY_TYPE, ASSEMBLY_ID, DESCRIPTION, PARENT_ASSEMBLY_TYPE, PARENT_ASSEMBLY_ID)
values
('A', 1234, 'Assembly A#1234', null, null);

insert into assembly
(ASSEMBLY_TYPE, ASSEMBLY_ID, DESCRIPTION, PARENT_ASSEMBLY_TYPE, PARENT_ASSEMBLY_ID)
values
('A', 1256, 'Assembly A#1256', 'A', 1234);

insert into assembly
(ASSEMBLY_TYPE, ASSEMBLY_ID, DESCRIPTION, PARENT_ASSEMBLY_TYPE, PARENT_ASSEMBLY_ID)
values
('B', 6543, 'Part Unit#6543', 'A', 1234);

insert into assembly
(ASSEMBLY_TYPE, ASSEMBLY_ID, DESCRIPTION, PARENT_ASSEMBLY_TYPE, PARENT_ASSEMBLY_ID)
values
('A', 1675, 'Part Unit#1675', 'B', 6543);

insert into assembly
(ASSEMBLY_TYPE, ASSEMBLY_ID, DESCRIPTION, PARENT_ASSEMBLY_TYPE, PARENT_ASSEMBLY_ID)
values
('X', 9943, 'Repair Zone 1', null, null);

insert into assembly
(ASSEMBLY_TYPE, ASSEMBLY_ID, DESCRIPTION, PARENT_ASSEMBLY_TYPE, PARENT_ASSEMBLY_ID)
values
('X', 5438, 'Repair Unit #5438', 'X', 9943);

insert into assembly
(ASSEMBLY_TYPE, ASSEMBLY_ID, DESCRIPTION, PARENT_ASSEMBLY_TYPE, PARENT_ASSEMBLY_ID)
values
('X', 1675, 'Readymade Unit #1675', 'X', 5438);

commit;


