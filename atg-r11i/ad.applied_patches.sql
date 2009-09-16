SELECT patch_name
     , to_char(creation_date,'dd/mm/yyyy hh24:mi:ss')
  FROM ad_applied_patches
 WHERE patch_name LIKE '%po%400%007%';



SELECT ap.patch_name
     , DECODE( LENGTH(patch_name)
             , 13, REPLACE( UPPER(SUBSTR(patch_name, 4)),'X',NULL)
             , 14, REPLACE( UPPER(SUBSTR(patch_name, 5)),'X',NULL)
             , patch_name
             ) as gap_name
     , creation_date
     , last_update_date
  FROM apps.ad_applied_patches ap
 WHERE patch_name like '%115%'
   AND LENGTH(patch_name) >= 13
 ORDER BY 2

-- to_char(ap.creation_date,'yyyy-mm-dd hh24:mi:ss') as creation_date



--CREATE TABLE wlr.ad_ap as
SELECT ap.patch_name
     , DECODE( LENGTH(patch_name)
             , 13, REPLACE( UPPER(SUBSTR(patch_name, 4)),'X',NULL)
             , 14, REPLACE( UPPER(SUBSTR(patch_name, 5)),'X',NULL)
             , patch_name
             ) as gap_name
     , creation_date
     , last_update_date
  FROM apps.ad_applied_patches ap
 WHERE patch_name like '%115%'
--   AND LENGTH(patch_name) >= 13
 ORDER BY 2

-- to_char(ap.creation_date,'yyyy-mm-dd hh24:mi:ss') as creation_date




-----------------------
wlr

select distinct patch
--     , object_name
     , creation_date
  from patch_x_object t
 where REPLACE(patch,'X',NULL) not in (select gap_name from ad_ap)
order by 2

begin
  update ad_ap
     set gap_name = replace(gap_name, '_', '-');
  commit;
end;


select * from ad_ap t

