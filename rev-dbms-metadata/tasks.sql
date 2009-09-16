

-- database

    -- database links
    -- dbms_jobs
    -- roles grants
    -- directory
    -- profiles

    -- controlfile
    -- redologs

-- schemas
    -? java
    -? queueu
    -? library
    -? materialized view
    -- comments
    
    
for user_name in (
                    select owner
                         , object_type
                         , count(1) as qtd
                      from dba_objects
                     where 1=1
                       and owner not like ('%SYS%')
                       and owner not in   ('XDB')
                     group by owner
                     order by 1                    )
 loop
        
    get_ddl        ( object_type, object_name, owner );
    get_granted_ddl( object_type, owner );
      
 end loop


SELECT dbms_metadata.get_ddl( object_type, object_name, owner )
  FROM dba_objects
 WHERE owner='SCOTT'
     ;
     
     
 


LEASE NOTE: This certification path will retire on August 30, 2009
