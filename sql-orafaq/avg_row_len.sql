REM  Compute and estimate statistics:

analyze table TABLENAME compute statistics;
analyze table TABLENAME estimate statistics;


REM  Selecting the average row length from the data dictionary:

select Avg_Row_Len
  from USER_TABLES
 where Table_Name = 'TABLENAME';

