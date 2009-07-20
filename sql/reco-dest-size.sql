--
-- reco-dest-size.sql
--    v$recovery_file_dest
--
-- Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
-- 2009-06
--

column name             format a30
column limit_giga       format 999g999g990d00
column used_giga        format 999g999g990d00
column free_giga        format 999g999g990d00
column reclaimable_giga format 999g999g990d00

select name
     , space_limit/1024/1024/1024               limit_giga
     , space_used/1024/1024/1024                used_giga
     , (space_limit-space_used)/1024/1024/1024  free_giga
     , space_reclaimable/1024/1024/1024         reclaimable_giga
     , number_of_files
  from v$recovery_file_dest
 where 1=1
--order by perc_used desc, tablespace_name
      ;

column percent_space_used           format 990d00
column percent_space_reclaimable    format 990d00

select *
  from v$flash_recovery_area_usage
 order by 1
     ;

