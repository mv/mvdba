--
-- My create
--
-- Marcus Vinicius Ferreira             ferreira.mv[ at ]gmail.com
-- 2009/Jun
--

-- connect system/sys@orcl

SET TERMOUT ON
SET FEEDBACK ON
SET ECHO ON

WHENEVER SQLERROR exit

CREATE USER top10 IDENTIFIED BY top10
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA 200M ON users
--  QUOTA 200M ON indx
    ;
    
GRANT CONNECT,RESOURCE TO top10;

@@sqlagrnt top10

