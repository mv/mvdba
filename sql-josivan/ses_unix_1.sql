/*
  SCRIPT:   SES_UNIX_1.SQL
  OBJETIVO: ANALISE DE PROCESSOS
  AUTOR:    JOSIVAN
  DATA:     
*/

SET ECHO           OFF     -
    FEEDBACK       OFF     -
    TERMOUT        ON      -
    LINESIZE       100     -
    PAUSE          OFF     -
    PAGESIZE       1000    -
    VERIFY         OFF

COL Proc_Unix   FORMAT A7      HEAding 'Proc.'
COL Serial      FORMAT 99999   HEAding 'Serial'
COL Sessao      FORMAT 999     HEAding 'Ses.'
COL Tabela      FORMAT A43     HEAding 'TY Tipo Req. Tabela (ou ultimo comando)'
COL Usr_Unix    FORMAT A10     HEAding 'Unix'
COL Usuario     FORMAT A10     HEAding 'Usuario'

BREAK on Sessao           -
      on Serial           -
      on Usuario          -
      on "Situacao"       -
      on Proc_Unix

/* DEFine Inv='[7m'
   DEFine Neg='[1m'
   DEFine Nor='[0m' */

select A.Sid                Sessao,
       A.Serial#            Serial,
       initcap(A.Username)  Usuario,
    -- A.Command
       lower(A.Status)      "Situacao",
    -- A.OsUser Usr_Unix,          -- VARCHAR2(15)
       A.Process Proc_Unix,        -- VARCHAR2(9)
    -- A.Terminal                  -- VARCHAR2(10)
    -- A.Type                      -- VARCHAR2(10)
    -- B.Id1,                      -- NUMBER
    -- B.Id2,                      -- NUMBER
    decode (B.LMode,
            null, '&Neg' || 
                  lower (decode (A.Command,
                    0, 'NADA',
                    1, 'CREATE TABLE',
                    2, 'INSERT',
                    3, 'SELECT',
                    4, 'CREATE CLUSTER',
                    5, 'ALTER CLUSTER',
                    6, 'UPDATE',
                    7, 'DELETE',
                    8, 'DROP',
                    9, 'CREATE INDEX',
                   10, 'DROP INDEX',
                   11, 'ALTER INDEX',
                   12, 'DROP TABLE',
                   13, 'CREATE SEQUENCE',
                   14, 'ALTER SEQUENCE',
                   15, 'ALTER TABLE',
                   16, 'DROP SEQUENCE',
                   17, 'GRANT',
                   18, 'REVOKE',
                   19, 'CREATE SYNONYM',
                   20, 'DROP SYNONYM',
                   21, 'CREATE VIEW',
                   22, 'DROP VIEW',
                   23, 'VALIDADE INDEX',
                   24, 'CREATE PROCEDURE',
                   25, 'ALTER PROCEDURE',
                   26, 'LOCK TABLE',
                   27, 'NO OPERATION',
                   28, 'RENAME',
                   29, 'COMMENT',
                   30, 'AUDIT',
                   31, 'NOAUDIT',
                   32, 'CREATE EXTERNAL DATABASE',
                   33, 'DROP EXTERNAL DATABASE',
                   34, 'CREATE DATABASE',
                   35, 'ALTER DATABASE',
                   36, 'CREATE ROLLBACK SEGMENT',
                   37, 'ALTER ROLLBACK SEGMENT',
                   38, 'DROP ROLLBACK SEGMENT',
                   39, 'CREATE TABLESPACE',
                   40, 'ALTER TABLESPACE',
                   41, 'DROP TABLESPACE',
                   42, 'ALTER SESSION',
                   43, 'ALTER USER',
                   44, 'COMMIT',
                   45, 'ROLLBACK',
                   46, 'SAVEPOINT',
                   47, 'PL/SQL EXECUTE',
                   48, 'SET TRANSACTION',
                   49, 'ALTER SYSTEM SWITCH LOG',
                   50, 'EXPLAIN',
                   51, 'CREATE USER',
                   52, 'CREATE ROLE',
                   53, 'DROP USER',
                   54, 'DROP ROLE',
                   55, 'SET ROLE',
                   56, 'CREATE SCHEMA',
                   57, 'CREATE CONTROL FILE',
                   58, 'ALTER TRACING',
                   59, 'CREATE TRIGGER',
                   60, 'ALTER TRIGGER',
                   61, 'DROP TRIGGER',
                   62, 'ANALYZE TABLE',
                   63, 'ANALYZE INDEX',
                   64, 'ANALYZE CLUSTER',
                   65, 'CREATE PROFILE',
                   66, '- 66 -',
                   67, 'DROP PROFILE',
                   68, 'ALTER PROFILE',
                   69, 'DROP PROCEDURE',
                   70, 'ALTER RESOURCE COST',
                   71, 'CREATE SNAPSHOT LOG',
                   72, 'ALTER SNAPSHOT LOG',
                   73, 'DROP SNAPSHOT LOG',
                   74, 'CREATE SNAPSHOT',
                   75, 'ALTER SNAPSHOT',
                   76, 'DROP SNAPSHOT',
--                 77, '- 77 -',
--                 78, '- 78 -',
                   79, 'ALTER ROLE',
--                 80, '- 80 -',
--                 81, '- 81 -',
--                 82, '- 82 -',
--                 83, '- 83 -',
--                 84, '- 84 -',
                   85, 'TRUNCATE TABLE',
                   86, 'TRUNCATE CLUSTER',
--                 87, '- 87 -',
                   88, 'ALTER VIEW',
--                 89, '- 89 -',
--                 90, '- 90 -',
                   91, 'CREATE FUNCTION',
                   92, 'ALTER FUNCTION',
                   93, 'DROP FUNCTION',
                   94, 'CREATE PACKAGE',
                   95, 'ALTER PACKAGE',
                   96, 'DROP PACKAGE',
                   97, 'CREATE PACKAGE BODY',
                   98, 'ALTER PACKAGE BODY',
                   99, 'DROP PACKAGE BODY',
                       '? ' || A.Command || ' ?')
                        ) || '&Nor',
           rpad (B.Type, 3) ||
           decode(B.LMode,
                    1, 'nada ',
                    2, 'RS   ',
                    3, 'RX   ',
                    4, 'S    ',
                    5, 'SRX  ',
                    6, 'X    ',
                       '     ') || 
           decode(B.Request,
                    1, 'nada ',
                    2, 'RS   ',
                    3, 'RX   ',
                    4, 'S    ',
                    5, 'SRX  ',
                    6, 'X    ',
                       '     ') || 
           decode (C.Name,
                     null, B.Id1 || ' - ' || B.Id2,
                  /* A.SchemaName || '.' || */ C.Name)) Tabela
    from v$session a
        ,v$lock b
        ,sys.obj$ c 
   where a.User#     >= 1
     and b.Sid(+)    =  a.Sid
     and c.Obj#(+)   =  b.Id1
order by a.Username
        ,a.Sid
        ,b.Addr
/
 
-- @$atb/ambiente
