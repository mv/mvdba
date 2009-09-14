
CREATE TABLE ad_ap as
SELECT ap.patch_name
  -- , length(patch_name) len
     , REPLACE(REPLACE(REPLACE( 
           REPLACE( LOWER(patch_name),'_','-') 
           , 'x',''), 'u115',''), '115','')
           as gap_name
     , creation_date
     , last_update_date
  FROM apps.ad_applied_patches ap
 WHERE patch_name like '%115%'
   AND LENGTH(patch_name) >= 13
 ORDER BY 2
 

select gap_name, creation_date
 from patches t
where LOWER(gap_name) not in (select LOWER(gap_name) from ad_ap)
  and gap_name NOT LIKE 'INST%'
  and gap_name NOT LIKE 'NST%'
  and gap_name NOT LIKE 'TST%'
  and gap_name NOT LIKE 'zas%'
order by 1