/*

  segmentos asfixiados, que nao conseguem mais crescer

*/

column usuario    format a10
column segmento   format a20
column tablespace format a15

select a.owner            usuario
      ,a.segment_name     segmento
      ,b.tablespace_name  tablespace
      ,decode(ext.extents,1,b.next_extent
                           ,a.bytes*(1+b.pct_increase/100)) next_extent
      ,freesp.largest     livre
  from dba_extents a
      ,dba_segments b
      ,(select owner
              ,segment_name
              ,max(extent_id) extent_id
              ,count(*)  extents
          from dba_extents
      group by owner
              ,segment_name ) ext
      ,(select tablespace_name
              ,max(bytes) largest
          from dba_free_space
      group by tablespace_name ) freesp
 where a.owner        = b.owner
   and a.segment_name = b.segment_name
   and a.owner        = ext.owner
   and a.segment_name = ext.segment_name
   and a.extent_id    = ext.extent_id
   and b.tablespace_name = freesp.tablespace_name
   and decode(ext.extents,1,b.next_extent
                           ,a.bytes*(1+b.pct_increase/100)) > freesp.largest
/
