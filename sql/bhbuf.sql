col class form A10
select decode(greatest(class,10),10,decode(class,1,'Data'
                                                ,2,'Sort'
                                                ,4,'Header'
                                                ,to_char(class))
             ,'Rollback')            "Class"
     , sum(decode(bitand(flag,1),1,0
                                ,1)) "Not Dirty"
     , sum(decode(bitand(flag,1),1,1
                                ,0)) "Dirty"
     , sum(dirty_queue)              "On Dirty"
     , count(*) "Total"
 from x$bh
group by decode(greatest(class,10),10,decode(class,1,'Data'
                                                  ,2,'Sort'
                                                  ,4,'Header'
                                                  ,to_char(class))
               ,'Rollback')
/

