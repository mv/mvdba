select ddf.tablespace_name
     , ddf.file_name
     , ddf.online_status
     , round(ddf.size_mega,2)  size_mega
     , round(dfs.free_mega,2)  free_mega
     , round(   free_mega/size_mega ,2)*100 perc_free
     , round(1-(free_mega/size_mega),2)*100 perc_used
  from (
        select tablespace_name
             , file_name
             , bytes/1024/1024  size_mega
             , online_status 
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
 order by perc_free, tablespace_name
    