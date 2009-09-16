REM  Calculating average row length

select AVG(NVL(VSIZE(Column1),0))+
       AVG(NVL(VSIZE(Column2),0))+
       AVG(NVL(VSIZE(Column3),0))   Avg_Row_Length
from TABLENAME;

