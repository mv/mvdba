--
-- Parâmetros da SGA
--
--    Marcus Vinicius Ferreira 24/Jul/2000
--
SET numformat 999g999g900
SET serveroutput ON SIZE 1000000
SET feedback OFF

COLUMN name  FORMAT A20
COLUMN value FORMAT 999g999g900

SELECT name SGA
     , value
  FROM v$sga
/

--
-----=================================================================================
--

COLUMN parameter FORMAT A40
COLUMN value     FORMAT 999g999g900

DECLARE
   --
   shared_pool_size           NUMBER;
   shared_pool_reserved_size  NUMBER;
   large_pool_size            NUMBER;
   db_block_size              NUMBER;
   db_block_buffers           NUMBER;
   log_buffer                 NUMBER;
   sga_total                  NUMBER:=0;
   --
   FUNCTION fmt (pivc_valor IN NUMBER) RETURN VARCHAR2 IS
   BEGIN
      RETURN (TO_CHAR(pivc_valor,'999g999g900'));
   END fmt;
   --
   FUNCTION fmt_m(pivc_valor IN NUMBER) RETURN VARCHAR2 IS
   BEGIN
      RETURN (TO_CHAR(pivc_valor/1024/1024,'999g999g900d00')||' Mbytes');
   END fmt_m;
   --
   FUNCTION f_param (pivc_pname IN VARCHAR2) RETURN VARCHAR2 IS
   -----
   --
      n_value NUMBER := -1;
   --
      CURSOR c_param (civc_pname IN VARCHAR2) is
      SELECT value
        FROM v$parameter
       WHERE name = CIVC_PNAME;
   BEGIN
      FOR r_param IN c_param (pivc_pname)
      LOOP
         n_value := r_param.value;
      END LOOP;
      --
      RETURN( n_value );
      --
   END f_param;
   --
   PROCEDURE printn IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE('.');
   END;
   --
   PROCEDURE printl(pivc_valor IN VARCHAR2) IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE(pivc_valor);
   END;
   --
   PROCEDURE print(pivc_valor IN VARCHAR2) IS
   BEGIN
      DBMS_OUTPUT.PUT(pivc_valor);
   END;
   --
BEGIN
   printn;
   printl('SGA');
   printl('===');
   printn;
   --
   shared_pool_size          := f_param('shared_pool_size');
   shared_pool_reserved_size := f_param('shared_pool_reserved_size');
   large_pool_size           := f_param('large_pool_size');
   sga_total                 := shared_pool_size + shared_pool_reserved_size + large_pool_size;
   --
   printl('Variable Size');
   printl('=============');
   printl('.    shared_pool_size          '||fmt(shared_pool_size)         ||fmt_m(shared_pool_size)         );
   printl('.    shared_pool_reserved_size '||fmt(shared_pool_reserved_size)||fmt_m(shared_pool_reserved_size));
   printl('.    large_pool_size           '||fmt(large_pool_size)          ||fmt_m(large_pool_size)          );
   printl('.                              ------------');
   printl('.                              '||fmt(sga_total)                ||fmt_m(sga_total)
                                           );
   --
   db_block_size    := f_param('db_block_size');
   db_block_buffers := f_param('db_block_buffers');
   --
   printl('Database Buffers');
   printl('================');
   printl('.    db_block_size             '||fmt(db_block_size   ));
   printl('.    db_block_buffers          '||fmt(db_block_buffers));
   printl('.                              ------------');
   printl('.                              '||fmt(db_block_size * db_block_buffers)
                                           ||fmt_m(db_block_size * db_block_buffers)
                                           );
   sga_total := sga_total + (db_block_size * db_block_buffers);
   --
   log_buffer := f_param('log_buffer');
   --
   printl('Redo Log Buffers');
   printl('================');
   printl('.    log_buffer                '||fmt(log_buffer)
                                           ||fmt_m(log_buffer) );
   printl('.                              '||'('||TO_CHAR(log_buffer / db_block_size)||' blocks)'
                                           );
   sga_total := sga_total + log_buffer;
   --
   printl('SGA TOTAL');
   printl('=========                      ----------------------------------');
   printl('.    TOTAL                     '||fmt(sga_total)
                                           ||fmt_m(sga_total)
                                           );
   --
END;
/

--
-----=================================================================================
--

COLUMN param FORMAT A25
COLUMN value FORMAT A20
SET feedback ON

SELECT name param
     , value
  FROM v$parameter
 WHERE name in ('sort_area_size'
               ,'sort_area_retained_size'
               ,'sort_write_buffer_size'
               ,'sort_write_buffers'
               ,'open_cursors'
               ,'processes'
               ,'dml_locks'
               )
/
