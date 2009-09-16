SET FEEDBACK OFF
SET ECHO OFF
SET SERVEROUTPUT ON SIZE 1000000
SET TRIMSPOOL ON

DECLARE
   ------------------------------------------------------------------------------
   -- rev.sql                                                           1.04
   --     Reverse Engineer from Oracle's Data Dictionary
   --     Anonymous Block Form (script form)
   --
   --     CREATED: Marcus Vinicius Ferreira     10/Jun/2000
   --     MODIFIED
   --         MVF - 08/Out/2000: NOT NULL constraints will be ignored
   --                            at column level when part of a PK
   --         MVF - 13/Out/2000: STORAGE included
   --         MVF - 13/Jan/2001: MAIN method
   --
   ----------------
   --
   vc_dlen        VARCHAR2(20);
   vc_linha       VARCHAR2(1024);
   vc_cons_name   VARCHAR2(50);
   vc_indent      VARCHAR2(90);
   storage_enable BOOLEAN := FALSE;
   pk_enable      BOOLEAN := FALSE;
   ck_enable      BOOLEAN := FALSE;
   fk_enable      BOOLEAN := TRUE;
   --
   ----- Tables
   --
   CURSOR c_tab IS
   SELECT table_name       tab_name
        , tablespace_name
        , initial_extent
        , next_extent
        , min_extents
        , max_extents
        , pct_free
        , pct_used
        , pct_increase
        , ini_trans
        , max_trans
        , freelists
        , freelist_groups freelg
        , DECODE(logging, 'NO','NOLOGGING'
                        , 'LOGGING') logging
        , DECODE(cache  , 'N' ,'NOCACHE'
                        , 'CACHE')   cache
        , buffer_pool
     FROM user_tables
  --WHERE rownum <=2
  /*WHERE table_name IN ('BENEFICIARIOS'
                        ,'CONTRATO_DI'
                        ,'CONTRATO_ROF'
                        ,'DI_ADICAO'
                        ,'OPERACAO_IMP'
                        ,'OPERACAO_IMP_ENDERECOS'
                        ,'OPERACAO_IMP_VENCIMENTOS'
                        ,'OPERACAO_IMP_VENCIMENTOS_COC'
                        ,'PAGAMENTO_REAIS'
                        ,'ROF_PARCELA'
                        )
  */ORDER BY 1;
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
   SELECT user_cons.constraint_name    constraint_name
        , user_cons.constraint_type    constraint_type
        , user_cons.search_condition   search_condition
        , user_cons.r_constraint_name  r_constraint_name
        , ref_cons.table_name          r_table_name
     FROM user_constraints  ref_cons
        , user_constraints  user_cons
    WHERE ref_cons.constraint_name (+) = user_cons.r_constraint_name
      AND user_cons.table_name         = PIVC_TAB_NAME
  --  AND ref_cons.table_name = 'MOEDA'
    ORDER BY DECODE( user_cons.constraint_type, 'P', 1
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
   ----- Nome da coluna na PK ?
/*   --
   FUNCTION f_col_pk ( pivc_tab_name IN VARCHAR2
                     , pivc_col_name IN VARCHAR2) RETURN BOOLEAN IS
   -----
      vc_cols VARCHAR2(500);
      n_size  NUMBER(5);
   --
      CURSOR c_col_pk ( civc_tab_name IN VARCHAR2
                      , civc_col_name IN VARCHAR2) IS
      SELECT column_name
        FROM user_constraints    cons
           , user_cons_columns   cols
       WHERE cons.constraint_type = 'P'
         AND cons.constraint_name = cols.constraint_name
         AND cols.column_name = UPPER(civc_col_name)
         AND cols.table_name  = UPPER(civc_tab_name)
       ;
   --
   BEGIN
   -- dbms_output.put_line ('###'||pivc_col_name||'###');
      FOR r1 IN c_col_pk( pivc_tab_name
                        , pivc_col_name)
      LOOP
         RETURN(TRUE);
      END LOOP;
      --
      RETURN( FALSE );
      --
   END f_col_pk;
*/   --
   ----- Nome da coluna na PK ?
   --
   FUNCTION f_col_pk ( pivc_tab_name IN VARCHAR2
                     , pivc_col_name IN VARCHAR2) RETURN BOOLEAN IS
   -----
      vc_cols VARCHAR2(500);
      n_size  NUMBER(5);
   --
      CURSOR c_col_pk ( civc_tab_name IN VARCHAR2
                      , civc_col_name IN VARCHAR2) IS
      SELECT column_name
        FROM user_constraints    cons
           , user_cons_columns   cols
       WHERE cons.constraint_type = 'P'
         AND cons.constraint_name = cols.constraint_name
         AND cols.column_name = UPPER(civc_col_name)
         AND cols.table_name  = UPPER(civc_tab_name)
       ;
   --
   BEGIN
   -- dbms_output.put_line ('###'||pivc_col_name||'###');
      FOR r1 IN c_col_pk( pivc_tab_name
                        , pivc_col_name)
      LOOP
         RETURN( TRUE );
      END LOOP;
      --
      RETURN( FALSE );
      --
   END f_col_pk;
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
   --------------------------
   -- Module 1
   --------------------------
   PROCEDURE p_tables IS
   BEGIN
      --
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
               print ('#  ( ');
            ELSE
               print ('#  , ');
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
                     vc_dlen := vc_dlen || ','||r2.data_scale;
                  END IF;
                  --
                  vc_dlen := vc_dlen || ')';
                  --
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
            IF r2.nullable IS NOT NULL           -- deve ser NULO
            AND NOT f_col_pk ( r1.tab_name       -- não deve fazer parte da PK
                             , r2.column_name)
            THEN
               vc_linha := vc_linha || r2.nullable ;
            END IF;
            --
            printl(vc_linha);
            --
         END LOOP;
         --
         ---- STORAGE
         --
         --   PCTFREE 10 PCTUSED 40
         --   INITRANS 1 MAXTRANS 255
         --   NOCACHE LOGGING
         --   TABLESPACE TS_UCAH_DT_01
         --   /*! STORAGE(INITIAL 122880
         --                  NEXT 106496
         --            MINEXTENTS 1 MAXEXTENTS 2147483645
         --           PCTINCREASE 0
         --             FREELISTS 1 FREELIST GROUPS 1
         --           BUFFER_POOL DEFAULT) !*/
         --
         IF storage_enable
         THEN
            printl('#  TABLESPACE '||r1.tablespace_name );
            printl('#  PCTFREE ' ||TO_CHAR(r1.pct_free) ||' PCTUSED ' ||TO_CHAR(r1.pct_used)  );
            printl('#  INITRANS '||TO_CHAR(r1.ini_trans)||' MAXTRANS '||TO_CHAR(r1.max_trans) );
            printl('#  /*! '  ||r1.cache ||' '||r1.logging    );
            printl('#   STORAGE(INITIAL '||TO_CHAR(r1.initial_extent)  );
            printl('#              NEXT '||TO_CHAR(r1.next_extent   )  );
            printl('#        MINEXTENTS '||TO_CHAR(r1.min_extents   )||' MAXEXTENTS '||TO_CHAR(r1.max_extents)  );
            printl('#       PCTINCREASE '||TO_CHAR(r1.pct_increase  )  );
            printl('#         FREELISTS '||TO_CHAR(r1.freelists     )||' FREELIST GROUPS '||TO_CHAR(r1.freelg)  );
            printl('#       BUFFER_POOL '||        r1.buffer_pool    ||' !*/'  );
         END IF;
         --
         ----
         --
         printl('#  )');
         --
         printl('/');
         --
         ---- END OF TABLE
         --
      END LOOP;
      --
   END p_tables;
   --
   -----
   --
   --------------------------
   -- Module 2
   --------------------------
   PROCEDURE p_constraints IS
   BEGIN
      --
      ----- User Tables
      --
      FOR r1 IN c_tab
      LOOP
         --
         FOR r3 IN c_tab_cons (r1.tab_name)
         LOOP
            -- identação depende do nome da tabela
            vc_indent := RPAD('# ',LENGTH(r1.tab_name)+ 27, ' ');
            --
            IF r3.constraint_name LIKE ('SYS%')
            THEN
               vc_cons_name := NULL;
            ELSE
               vc_cons_name := r3.constraint_name||' ';
            END IF;
            --
            IF  r3.constraint_type = 'P'
            AND pk_enable
            THEN
               print ('ALTER TABLE '    ||LOWER(r1.tab_name)            );
               print (' ADD CONSTRAINT '||LOWER(vc_cons_name)           );
               printl('PRIMARY KEY ('   ||f_colunas(r3.constraint_name)||');' );
            END IF;
            -- NOT NULL just at column level
            IF  r3.constraint_type = 'C'
            AND ck_enable
          --AND vc_cons_name IS NOT NULL
            AND SUBSTR(r3.search_condition, -11) <> 'IS NOT NULL'
            THEN
               print ('ALTER TABLE '    ||LOWER(r1.tab_name)     );
               printl(' ADD CONSTRAINT '||LOWER(vc_cons_name)    );
               printl(vc_indent
                      ||' CHECK ('      ||r3.search_condition ||');'  );
            END IF;
            -- REFERENCES
            IF  r3.constraint_type = 'R'
            AND fk_enable
            THEN
               print ('ALTER TABLE '      ||LOWER(r1.tab_name)        );
               printl(' ADD CONSTRAINT '  ||LOWER(vc_cons_name)       );
               printl(vc_indent
                      ||' FOREIGN KEY ('  ||f_colunas(r3.constraint_name)||')'  );
               printl(vc_indent
                      ||' REFERENCES '    ||LOWER(r3.r_table_name)
                                          ||'('
                                          ||f_colunas(r3.r_constraint_name)
                                          ||') ;' );
            END IF;
            --
         END LOOP;
         --
     /*  printl('#');
         printl('#');
         printl('#');
     */  --
      END LOOP;
      --
   END p_constraints;
   --
   -----
   --
BEGIN
   --------------------------
   -- Main....
   --------------------------
   printl('-----  Rev.sql');
   printl('-----     1.04');
   printl('-----  Schema: '||USER);
   printl('-----    Data: '||TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS') );
   printl('----- ');
   ----
   --
 --p_tables;
   --
   p_constraints;
   --
   --
END;
/

SET FEEDBACK ON
SET ECHO ON

-- @E:\rev.sql
