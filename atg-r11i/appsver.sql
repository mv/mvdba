-- $Id: appsver.sql 8438 2007-01-25 14:18:47Z marcus.ferreira $
-- http://www.orafaq.com/scripts/apps/appsver.txt
rem -----------------------------------------------------------------------
rem Filename:   appsver.sql
rem Purpose:    Print Oracle Apps versions
rem Author:     Anonymous
rem -----------------------------------------------------------------------

SELECT substr(a.application_short_name, 1, 5) code,
       substr(t.application_name, 1, 50) application_name,
       p.product_version version
FROM   fnd_application a,
       fnd_application_tl t,
       fnd_product_installations p
WHERE  a.application_id = p.application_id
AND    a.application_id = t.application_id
AND    t.language = USERENV('LANG')
/