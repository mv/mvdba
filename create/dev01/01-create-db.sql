
connect "SYS"/"&&sysPassword" as SYSDBA

set echo on
spool /u01/app/oracle/admin/dev01/create/01-create-db.log

startup nomount pfile="/u01/app/oracle/admin/dev01/pfile/initdev01.ora";

CREATE DATABASE "dev01"
    MAXINSTANCES 32
    MAXLOGFILES 192
    MAXLOGMEMBERS 5
    MAXLOGHISTORY 5
    MAXDATAFILES 1024
    DATAFILE '/u02/oradata/dev01/system01.dbf'
        SIZE 300M
        AUTOEXTEND ON NEXT 10M MAXSIZE 2G
        EXTENT MANAGEMENT LOCAL
    SYSAUX DATAFILE '/u02/oradata/dev01/sysaux01.dbf'
        SIZE 120M
        AUTOEXTEND ON NEXT 10M MAXSIZE 2G
        SMALLFILE
    DEFAULT TABLESPACE USERS
        DATAFILE '/u02/oradata/dev01/users01.dbf'
        SIZE 20M
        AUTOEXTEND ON NEXT 1M MAXSIZE 2G
        SMALLFILE
    DEFAULT TEMPORARY TABLESPACE TEMP
        TEMPFILE '/u02/oradata/dev01/temp01.dbf'
        SIZE 20M
        AUTOEXTEND ON NEXT 1M MAXSIZE 4G
        SMALLFILE
    UNDO TABLESPACE "UNDO"
        DATAFILE '/u02/oradata/dev01/undo01.dbf'
        SIZE 200M
        AUTOEXTEND ON NEXT 5M MAXSIZE 4G
    CHARACTER SET WE8ISO8859P1
    NATIONAL CHARACTER SET AL16UTF16
    CONTROLFILE REUSE
    NOARCHIVELOG
    LOGFILE GROUP 1 ( '/u01/oradata/dev01/gr01-m01.rdo'
                    , '/u02/oradata/dev01/gr01-m02.rdo'
                    , '/u03/oradata/dev01/gr01-m03.rdo'
                    ) SIZE 50M REUSE
          , GROUP 2 ( '/u01/oradata/dev01/gr02-m01.rdo'
                    , '/u02/oradata/dev01/gr02-m02.rdo'
                    , '/u03/oradata/dev01/gr02-m03.rdo'
                    ) SIZE 50M REUSE
          , GROUP 3 ( '/u01/oradata/dev01/gr03-m01.rdo'
                    , '/u02/oradata/dev01/gr03-m02.rdo'
                    , '/u03/oradata/dev01/gr03-m03.rdo'
                    ) SIZE 50M REUSE
    USER SYS    IDENTIFIED BY "&&sysPassword"
    USER SYSTEM IDENTIFIED BY "&&systemPassword"
    ;

-- Rac:
--    Generated named controlfiles
--
-- set linesize 2048;
-- column ctl_files NEW_VALUE ctl_files;
-- 
-- select concat('control_files=''', concat(replace(value, ', ', ''','''), '''')) ctl_files
--   from v$parameter
--  where name ='control_files';
-- 
-- host echo &ctl_files >>/u01/app/oracle/admin/dev01/scripts/init.ora;

spool off

