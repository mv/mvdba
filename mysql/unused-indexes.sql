
-- Ref: http://www.mysqlperformanceblog.com/2009/01/15/dropping-unused-indexes/
--      http://www.mysqlperformanceblog.com/2008/09/12/unused-indexes-by-single-query/
-- Pre-requisite: percona extensions

SELECT concat('alter table ',d.table_schema,'.',d.table_name,' drop index ',group_concat(index_name separator ',drop index '),';') stmt
  FROM (   SELECT DISTINCT s.TABLE_SCHEMA, s.TABLE_NAME, s.INDEX_NAME
             FROM information_schema.statistics s
        LEFT JOIN information_schema.index_statistics iz
               ON (    s.TABLE_SCHEMA = iz.TABLE_SCHEMA
                   AND s.TABLE_NAME=iz.TABLE_NAME
                   AND s.INDEX_NAME=iz.INDEX_NAME)
            WHERE iz.TABLE_SCHEMA IS NULL
              AND s.NON_UNIQUE=1
              AND s.INDEX_NAME!='PRIMARY'
              AND (SELECT rows_read+rows_changed
                     FROM information_schema.table_statistics ts
                    WHERE ts.table_schema=s.table_schema
                      AND ts.table_name=s.table_name)>0) d
 GROUP BY table_schema,table_name

-- vim: ft=mysql:

