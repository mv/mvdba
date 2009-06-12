--
-- ddf.sql
--    tablespace x datafile %free
--
-- Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
-- 2009-06
--

column tablespace_name  format a25
column file_name        format a50
column perc_free        format 999
column perc_used        format 999
column size_mega        format 999g999g990d00
column free_mega        format 999g999g990d00
column h_size           format a10
column h_free           format a10

select ddf.tablespace_name
     , chr(39)||ddf.file_name||chr(39)              file_name
     , ddf.online_status                            status
     , decode (sign( 1000 - ddf.size_mega )
              , 1, LPAD(   round(ddf.size_mega,2) || ' M', 10, ' ')
              , LPAD( round(ddf.size_mega/1000,2) || ' G', 10, ' ')
              )                                     h_size
     , decode (sign( 1000 - dfs.free_mega )
              , 1, LPAD(   round(dfs.free_mega,2) || ' M', 10, ' ')
              , LPAD( round(dfs.free_mega/1000,2) || ' G', 10, ' ')
              )                                     h_free
     , round(   free_mega/size_mega ,2)*100         perc_free
     , round(1-(free_mega/size_mega),2)*100         perc_used
--   , round(ddf.size_mega,2)                       size_mega
--   , round(dfs.free_mega,2)                       free_mega
--   , round(ddf.maxsize_mega,2)                    maxsize_mega
     , decode (ddf.maxsize_mega
              , 0, '       -'
              , decode (sign( 1000 - ddf.maxsize_mega )
                       , 1, LPAD(   round(ddf.maxsize_mega,2) || ' M', 10, ' ')
                       , LPAD( round(ddf.maxsize_mega/1000,2) || ' G', 10, ' ')
                       )
              )                                     h_maxsize
     , decode (ddf.increment_by
              , 0, '       -'
              , decode (sign( 1000 - ddf.increment_by )
                       , 1, LPAD(   round(ddf.increment_by,2) || ' M', 10, ' ')
                       , LPAD( round(ddf.increment_by/1000,2) || ' G', 10, ' ')
                       )
              )                                     h_auto_ext
--   , ddf.increment_by
  from (
        select tablespace_name
             , file_name
             , bytes/1024/1024      size_mega
             , maxbytes/1024/1024   maxsize_mega
             , online_status
             , autoextensible       auto_extend
             , increment_by
          from dba_data_files
         order by 1,2
       ) ddf
       , (
        select tablespace_name
             , sum(bytes)/1024/1024 free_mega
          from dba_free_space
          group by tablespace_name
          order by tablespace_name
       ) dfs
  where 1=1
    and ddf.tablespace_name = dfs.tablespace_name
  order by perc_used desc, tablespace_name
      ;

