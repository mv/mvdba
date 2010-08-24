--
-- Ref: http://dev.mysql.com/tech-resources/articles/mysql_5.1_partitioning_with_dates.html
--

CREATE TABLE part_date3
( c1  int          default  NULL
, c2  varchar(30)  default  NULL
, c3  date         default  NULL
) engine=myisam
partition by range (to_days(c3))
( PARTITION p00 VALUES LESS THAN ( to_days('1995-01-01') )
, PARTITION p01 VALUES LESS THAN ( to_days('1996-01-01') )
, PARTITION p02 VALUES LESS THAN ( to_days('1997-01-01') )
, PARTITION p03 VALUES LESS THAN ( to_days('1998-01-01') )
, PARTITION p04 VALUES LESS THAN ( to_days('1999-01-01') )
, PARTITION p05 VALUES LESS THAN ( to_days('2000-01-01') )
, PARTITION p06 VALUES LESS THAN ( to_days('2001-01-01') )
, PARTITION p07 VALUES LESS THAN ( to_days('2002-01-01') )
, PARTITION p08 VALUES LESS THAN ( to_days('2003-01-01') )
, PARTITION p09 VALUES LESS THAN ( to_days('2004-01-01') )
, PARTITION p10 VALUES LESS THAN ( to_days('2010-01-01') )
, PARTITION p11 VALUES LESS THAN MAXVALUE
);


CREATE TABLE part_date4
( c1  int          default  NULL
, c2  varchar(30)  default  NULL
, c3  date         default  NULL
)  engine=myisam
partition by range (year(c3))
( PARTITION p00 VALUES LESS THAN (1995)
, PARTITION p01 VALUES LESS THAN (1996)
, PARTITION p02 VALUES LESS THAN (1997)
, PARTITION p03 VALUES LESS THAN (1998)
, PARTITION p04 VALUES LESS THAN (1999)
, PARTITION p05 VALUES LESS THAN (2000)
, PARTITION p06 VALUES LESS THAN (2001)
, PARTITION p07 VALUES LESS THAN (2002)
, PARTITION p08 VALUES LESS THAN (2003)
, PARTITION p09 VALUES LESS THAN (2004)
, PARTITION p10 VALUES LESS THAN (2010)
, PARTITION p11 VALUES LESS THAN MAXVALUE
);

explain partitions
    select count(*) from part_date3
     where c3 > date '1995-01-01'
       and c3 < date '1995-12-31'
     \G

explain partitions
    select count(*) from part_date4
     where c3 > date '1995-01-01'
       and c3 < date '1995-12-31'
    \G

