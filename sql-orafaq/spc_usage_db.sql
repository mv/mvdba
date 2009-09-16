REM  Space usage in the database

select
      Tablespace_Name,   /*Tablespace name*/
      Owner,             /*Owner of the segment*/
      Segment_Name,      /*Name of the segment*/
      Segment_Type,      /*Type of segment (ex. TABLE, INDEX)*/
      Extents,           /*Number of extents in the segment*/
      Blocks,            /*Number of db blocks in the segment*/
      Bytes              /*Number of bytes in the segment*/
from DBA_SEGMENTS
/
