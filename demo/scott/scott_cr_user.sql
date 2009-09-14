-- scott_user.sql

CREATE USER scott IDENTIFIED BY tiger
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA 10M on users
    QUOTA 10M on indx
/

GRANT CONNECT,RESOURCE TO scott
/

-- @C:\work\dba\schema\scott\scott_cr_user.sql


