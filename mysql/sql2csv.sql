
SELECT * FROM cities
  INTO OUTFILE '/tmp/cities.csv'
       FIELDS TERMINATED BY ',' ENCLOSED BY '"'
       LINES  TERMINATED BY '\n'
  ;

