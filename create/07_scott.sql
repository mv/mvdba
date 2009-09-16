-- $Id: 07_scott.sql 12704 2007-03-29 19:47:19Z marcus.ferreira $

CONNECT SYS/oracle AS SYSDBA

    CREATE USER scott
        IDENTIFIED BY tiger
        DEFAULT TABLESPACE users
        QUOTA 200M ON users
        QUOTA 200M ON indx
        ;

    GRANT CONNECT,RESOURCE,CREATE VIEW TO scott;

CONNECT scott/tiger

    @?/rdbms/admin/utlexcpt.sql
    @?/rdbms/admin/utlxplan.sql

    @?/sqlplus/demo/demobld.sql
