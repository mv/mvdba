
use bbs_production;


SELECT u.id
     , u.firstname
     , u.lastname
     , u.email
     , u.permalink
     , u.created_at
  INTO OUTFILE '/tmp/netto.tsv' FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
  FROM users    u
     , profiles p
 WHERE u.id         = p.user_id
   AND u.verified   = 1
   AND u.deleted    = '0'
   AND u.status     = '0'
   AND p.newsletter = '1'
     ;
