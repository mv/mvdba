--
--
-- Oracle
--    Database creation corrections
--
-- Usage:
--    sqlplus system@db < post-create.sql
--
--    Marcus Vinicius Ferreira                  ferreira.mv[ at ] gmail.com
--    2009-06
--

alter user system default tablespace users;
alter user scott  default tablespace users;

revoke unlimited tablespace from scott;
revoke create database link from connect;

grant create view to resource;
grant create database link to resource;

grant select_catalog_role to public;

-- vim:set ft=plsql:

