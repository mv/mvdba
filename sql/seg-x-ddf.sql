/*

  verificar em quais datafiles esta espalhado um segmento

*/

select df.name 
  from v$datafile df
      ,dba_extents ext
 where df.file#        = ex.file_id
   and ex.owner        = 'OCPEDBA'
   and ex.segment_name = 'TRANS_ABAST';

