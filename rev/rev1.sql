-- $Id: rev1.sql 6 2006-09-10 15:35:16Z marcus $
SET FEEDBACK OFF
SET ECHO OFF
SET SERVEROUTPUT ON SIZE 1000000
DECLARE
   --
   vc_dlen        VARCHAR2(20);
   vc_linha       VARCHAR2(1024);
   vc_cons_name   VARCHAR2(30);
   --
   ----- Tables
   --
   CURSOR c_tab IS
   SELECT table_name       tab_name
        , tablespace_name
     FROM user_tables
    ORDER BY 1;
   --
   ----- Colunas
   --
   CURSOR c_tab_cols (pivc_tab_name IN VARCHAR2) IS
   SELECT LOWER(column_name)        column_name
        , column_id
        , data_type
        , DECODE(nullable, 'Y', ''
                         , 'N', 'NOT NULL') nullable
        , TO_CHAR(data_precision)   data_precision
        , TO_CHAR(data_scale)       data_scale
        , TO_CHAR(data_length)      data_length
        , data_default
     FROM user_tab_columns
    WHERE table_name = PIVC_TAB_NAME
    ORDER BY table_name
           , column_id;
   --
   ----- Table Constraints
   --
   CURSOR c_tab_cons (pivc_tab_name IN VARCHAR2) IS
   SELECT constraint_name
        , constraint_type
        , search_condition
     FROM user_constraints
    WHERE table_name = PIVC_TAB_NAME
    ORDER BY DECODE( constraint_type, 'P', 1
                                    , 'R', 2
                                    , 'C', 3);
   --
   ----- Nome das colunas em constraints
   --
   FUNCTION f_colunas (pivc_cons_name IN VARCHAR2) RETURN VARCHAR2 IS
   -----
      vc_cols VARCHAR2(500);
      n_size  NUMBER(5);
   --
      CURSOR c_cols (civc_cons_name IN VARCHAR2) IS
      SELECT column_name
        FROM user_cons_columns
       WHERE constraint_name = civc_cons_name
       ORDER BY position;
   --
   BEGIN
   -- dbms_output.put_line ('###'||pivc_cons_name||'###');
      FOR r1 IN c_cols(pivc_cons_name)
      LOOP
         vc_cols := vc_cols || LOWER(r1.column_name) || ',' ;
      END LOOP;
      --
      n_size := LENGTH( vc_cols ) - 1;
      --
      RETURN( SUBSTR(vc_cols, 1, n_size ) );
      --
   END f_colunas;
   --
   -----
   --
   PROCEDURE print (pivc_msg IN VARCHAR2) IS
   BEGIN
      DBMS_OUTPUT.PUT (pivc_msg);
   END print;
   --
   -----
   --
   PROCEDURE printl(pivc_msg IN VARCHAR2) IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE (pivc_msg);
   END printl;
   --
   -----
   --
BEGIN
   ----
   -- User_Tables
   FOR r1 IN c_tab
   LOOP
      ----
      -- Cabeçalho
      printl('--');
      printl('-- Gerado em '||TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
      printl('--');
      printl('CREATE TABLE '||LOWER(r1.tab_name));
      --
      FOR r2 IN c_tab_cols (r1.tab_name)
      LOOP
         -- Início da coluna
         IF r2.column_id = 1
         THEN
            print ('   ( ');
         ELSE
            print ('   , ');
         END IF;
         --
         print ( RPAD(r2.column_name, 30, ' ') );
         --
         vc_dlen := NULL;
         IF r2.data_type = 'NUMBER'
         THEN
            --
            ----- Usando PRECISION/SCALE quando presentes
            --
            IF r2.data_precision IS NOT NULL
            THEN
               --
               vc_dlen := '('||r2.data_precision ;
               --
               IF  r2.data_scale IS NOT NULL
               AND r2.data_scale != '0'
               THEN
                  vc_dlen := vc_dlen || ','||r2.data_scale||')';
               ELSE
                  vc_dlen := vc_dlen || ')';
               END IF;
            ELSE
            --
            ----- Usando LENGTH quando específico
            --
               IF r2.data_length NOT IN ('22','29')
               THEN
                  vc_dlen := '('||r2.data_length||')';
               END IF;
            --
            END IF;
            --
         ELSIF r2.data_type = 'DATE'
         THEN
            vc_dlen := NULL;
         ELSE
            vc_dlen := '('||r2.data_length||')' ;
         END IF;
         --
         ----- Default?
         --
         vc_linha := RPAD(r2.data_type || vc_dlen, 15, ' ' );
         IF r2.data_default IS NOT NULL
         THEN
            vc_linha := vc_linha ||'DEFAULT '||r2.data_default || ' ';
         END IF;
         --
         ----- NULL?
         --
         IF r2.nullable IS NOT NULL
         THEN
            vc_linha := vc_linha || r2.nullable ;
         END IF;
         --
         printl(vc_linha);
         --
      END LOOP;
      --
      printl(')');
      --
      printl('/');
      --
      FOR r3 IN c_tab_cons (r1.tab_name)
      LOOP
         --
         IF r3.constraint_name LIKE ('SYS%')
         THEN
            vc_cons_name := NULL;
         ELSE
            vc_cons_name := r3.constraint_name||' ';
         END IF;
         --
         IF r3.constraint_type = 'P'
         THEN
            print ('ALTER TABLE '    ||LOWER(r1.tab_name)            );
            print (' ADD CONSTRAINT '||LOWER(vc_cons_name)           );
            printl('PRIMARY KEY ('   ||f_colunas(r3.constraint_name)||');' );
         END IF;
         -- not null just at column level
         IF  r3.constraint_type = 'C'
         AND vc_cons_name IS NOT NULL -- LIKE 'sys%'
         THEN
            print ('ALTER TABLE '    ||LOWER(r1.tab_name)        );
            print (' ADD CONSTRAINT '||LOWER(vc_cons_name)       );
            printl('CHECK ('        ||r3.search_condition||');'  );
         END IF;
         -- REFERENCES
      END LOOP;
      --
      printl('');
      printl('');
      printl('');
      --
   END LOOP;
   --
   --
END;
/

SET FEEDBACK ON
SET ECHO ON
