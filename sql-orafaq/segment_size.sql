REM  Extent sizes for a segment:

select
      Tablespace_Name,   /*Tablespace name*/
      Owner,             /*Owner of the segment*/
      Segment_Name,      /*Name of the segment*/
      Segment_Type,      /*Type of segment (ex. TABLE, INDEX)*/
      Extent_ID,         /*Extent number in the segment*/
      Block_ID,          /*Starting block number for the extent*/
      Bytes,             /*Size of the extent, in bytes*/
      Blocks             /*Size of the extent, in Oracle blocks*/
 from DBA_EXTENTS
where Segment_Name = 'segment_name'
order by Extent_ID;

