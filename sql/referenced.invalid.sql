
SELECT DISTINCT referenced_name
     , 'alter view '||RPAD(refereced_name,31,' ')||' compile;'
  FROM user_dependencies
 WHERE 1=1
   AND referenced_type = 'VIEW'
   AND name IN (
        SELECT object_name
          FROM user_objects
         WHERE 1=1
           AND status <> 'VALID'
           AND object_type IN ('PACKAGE BODY')
           )
