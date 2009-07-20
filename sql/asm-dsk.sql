--
-- asm-dsk.sql
--    asm disk x diskgroup
--
-- Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
-- 2009-07
--


column dg_name          format a15
column failgroup        format a15
column path             format a15
column total_giga       format 999g999d00
column usable_giga      format 999g999d00
column free             format 999g999d00
column perc_free        format 999g999d00

column dsk_name         format a15
column dsk_size         format 999g999d00
column dsk_free         format 999g999d00
column dsk_used         format 999g999d00

select dg.name                          dg_name
     , dg.group_number
     , dg.state                         dg_state
     , dg.type                          type
     , dg.total_mb/1024                 total_giga
     , usable_file_mb/1024              usable_giga
     , dg.free_mb/1024                  free
     , dg.free_mb/dg.total_mb*100       perc_free
     , sector_size
     , block_size
     , allocation_unit_size             au_size
     , offline_disks
     , unbalanced
  from v$asm_diskgroup dg
 where 1=1
 order by dg.name
/

select dg.name                          dg_name
     , dsk.group_number
     , dsk.disk_number
     , dsk.name                         dsk_name
     , dsk.failgroup
     , dsk.path
     , dsk.total_mb/1024                dsk_size
     , (dsk.total_mb-dsk.free_mb)/1024  dsk_used
     , dsk.free_mb/1024                 dsk_free
     , dsk.free_mb/dsk.total_mb*100     dsk_perc_free
     , dsk.state                        dsk_state
     , dsk.redundancy
     , dsk.mount_status
     , dsk.header_status
     , dsk.mode_status
     , dsk.mount_date
--   , dsk.create_date
  from v$asm_diskgroup dg
     , v$asm_disk      dsk
 where dg.group_number = dsk.group_number
 order by dg.name, dsk.group_number, dsk.disk_number
/


