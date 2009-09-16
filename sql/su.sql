-- $Id: su.sql 18665 2007-08-22 18:37:24Z marcus.ferreira $
-- $URL: http://aurora.alejandro.inf.br:8080/repos/mdias/salto/branch/marcus.ferreira/sql/su.sql $
-- http://asktom.oracle.com/tkyte/Misc/su.html

WHENEVER SQLERROR EXIT

VARIABLE l_passwd VARCHAR2(30)

BEGIN
    SELECT password INTO :l_passwd
      FROM sys.dba_users
     WHERE username = UPPER('&1');
END;
/

ALTER USER &1 IDENTIFIED BY HELLO;
CONNECT &1/HELLO

BEGIN
    EXECUTE IMMEDIATE 'ALTER USER &1 IDENTIFIED BY VALUES '||CHR(39)|| :l_passwd||CHR(39) ;
END;
/

SHOW USER

WHENEVER SQLERROR CONTINUE

