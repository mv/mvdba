REM  Generating a chained row listing

analyze table TABLE_NAME list chained rows into CHAINED_ROWS;


REM  Listing chained rows

select
       Owner_Name,      /*Owner of the data segment*/
       Table_Name,      /*Name of the table with the chained rows*/
       Cluster_Name,    /*Name of the cluster, if it is clustered*/
       Head_RowID       /*Rowid of the first part of the row*/
from CHAINED_ROWS;

