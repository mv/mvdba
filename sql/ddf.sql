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
column perc_used_max    format a15 justify right
column size_mega        format 999g999g990d00
column free_mega        format 999g999g990d00
column filesize         format a10
column free             format a10

prompt
prompt Total
prompt -----

select decode (sign( 1024 - ddf.size_mega )
              , 1, LPAD(   round(ddf.size_mega,2) || ' M', 10, ' ')
              , LPAD( round(ddf.size_mega/1024,2) || ' G', 10, ' ')
              )                                     filesize
     , decode (sign( 1024 - dfs.free_mega )
              , 1, LPAD(   round(dfs.free_mega,2) || ' M', 10, ' ')
              , LPAD( round(dfs.free_mega/1024,2) || ' G', 10, ' ')
              )                                     free
     , decode (sign( 1024 - ddf.maxsize_mega )
              , 1, LPAD(   round(ddf.maxsize_mega,2) || ' M', 10, ' ')
              , LPAD( round(ddf.maxsize_mega/1024,2) || ' G', 10, ' ')
              )                                     max_size
     , round(   free_mega/size_mega ,2)*100         perc_free
     , round(1-(free_mega/size_mega),2)*100         perc_used
  from (
        select sum(bytes)/1024/1024    size_mega
             , sum(maxbytes)/1024/1024 maxsize_mega
          from dba_data_files
       ) ddf
       , (
        select sum(bytes)/1024/1024   free_mega
          from dba_free_space
       ) dfs
  where 1=1
      ;

prompt
prompt Detalhes
prompt --------

select ddf.tablespace_name
     , chr(39)||ddf.file_name||chr(39)                                          file_name
     , ddf.online_status                                                        status
     , decode (sign( 1024 - ddf.size_mega )
              , 1, LPAD(   round(ddf.size_mega,2) || ' M', 10, ' ')
              , LPAD( round(ddf.size_mega/1024,2) || ' G', 10, ' ')
              )                                                                 filesize
     , decode (sign( 1024 - dfs.free_mega )
              , 1, LPAD(   round(dfs.free_mega,2) || ' M', 10, ' ')
              , LPAD( round(dfs.free_mega/1024,2) || ' G', 10, ' ')
              )                                                                 free
--   , LPAD(round(   free_mega/size_mega ,2)*100 || ' %', 10, ' ')              perc_free
     , LPAD(round(1-(free_mega/size_mega),2)*100 || ' %', 10, ' ')              perc_used
     , decode (ddf.maxsize_mega
              , 0, ' '
              , decode (sign( 1024 - ddf.maxsize_mega )
                       , 1, LPAD(   round(ddf.maxsize_mega,2) || ' M', 10, ' ')
                       , LPAD( round(ddf.maxsize_mega/1024,2) || ' G', 10, ' ')
                       )
              )                                                                 maxsize
     , decode (ddf.maxsize_mega
              , 0, ' '
              , LPAD(round((ddf.size_mega/maxsize_mega),2)*100 || ' %' , 15, ' ')
              )                                                                 perc_used_max -- percent used to reach maxsize
--   , round(ddf.size_mega,2)                                                   size_mega
--   , round(dfs.free_mega,2)                                                   free_mega
--   , round(ddf.maxsize_mega,2)                                                maxsize_mega
     , ddf.extend
     , online_status
  from (
        select tablespace_name
             , file_name
             , bytes/1024/1024      size_mega
             , maxbytes/1024/1024   maxsize_mega
             , online_status
             , autoextensible       extend
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
    and ddf.tablespace_name (+) = dfs.tablespace_name
--order by perc_free asc, tablespace_name
  order by tablespace_name
      ;

