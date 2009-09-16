DECLARE
   --
   ---- para STORED PROCEDURE: retirar DECLARE e bloco anônimo ao final
   --
   PROCEDURE p_exp_loader( pivc_table_name IN VARCHAR2
                         , pivc_owner      IN VARCHAR2 DEFAULT NULL
                         , pivc_path       IN VARCHAR2 DEFAULT NULL
                         , pivc_sep        IN VARCHAR2 DEFAULT NULL
                         , pivc_header     IN VARCHAR2 DEFAULT NULL) IS
   ----------------
   --  p_exp_loader: exporta uma tabela em formato SQL*Loader
   --
   --  HISTORY
   --     09/Ago/2000 - Marcus Vinicius Ferreira - Criação
   --     11/Ago/2000 - formato PROCEDURE + parâmetros
   --
      -- Arquivo
         fh          UTL_FILE.FILE_TYPE;
         gvc_owner   VARCHAR2(30);        -- schema
         gvc_path    VARCHAR2(255):= NVL(pivc_path, '/traba/exp');
         gvc_sep     VARCHAR2(1)  := NVL(pivc_sep   , ',');  -- separador
         gvc_header  VARCHAR2(1)  := NVL(pivc_header, 'S');  -- imprime HEADER ?
      -- SQL Dyn
         vc_sep      VARCHAR2(1);
         vc_sql      VARCHAR2(4000);
         sqlh        NUMBER;
         discard     NUMBER;
      --
         TYPE rec_tab IS RECORD( col VARCHAR2(30)   -- nome da coluna
                               , typ VARCHAR2(30)   -- datatype
                               , tam NUMBER         -- tamanho
                               , vc  VARCHAR2(4000) -- valor: varchar2
                               , dt  DATE           -- valor: date
                               , num NUMBER);       -- valor: num
         TYPE  t_tab IS TABLE OF rec_tab INDEX BY BINARY_INTEGER;
         a_tab T_TAB;
         -- LONG
         vc_long     VARCHAR2(4000);                -- apenas 1 por tabela(i.e., fica
         n_tam       NUMBER := 4000;                -- fora do array)
         n_pos       NUMBER := 1;
         n_bytes     NUMBER := 0;
         end_of_long BOOLEAN := FALSE;
      --
      --- print: concatena
      PROCEDURE print (pivc_valor IN VARCHAR2) IS
      BEGIN
         UTL_FILE.PUT(fh, pivc_valor);
         --DBMS_OUTPUT.PUT(pivc_valor);
      END print;
      --
      --- printl: quebra a linha
      PROCEDURE printl(pivc_valor IN VARCHAR2) IS
      BEGIN
         UTL_FILE.PUT_LINE(fh, pivc_valor);
         --DBMS_OUTPUT.PUT_LINE(pivc_valor);
      END printl;
      --
      FUNCTION quote (pivc_valor IN VARCHAR2) RETURN VARCHAR2 IS
      BEGIN
         RETURN( '"' || pivc_valor || '"' );
      END quote;
      -----
   BEGIN
      --
      --- Arquivo
      --
      IF pivc_owner IS NOT NULL
      THEN
         gvc_owner := gvc_owner || '_';
      END IF;
      --
      fh := UTL_FILE.FOPEN(vc_path
                          ,LOWER(gvc_owner)||LOWER(pivc_table_name)||'.dat'
                          ,'W');
      --
      vc_sep  := NULL;
      vc_sql  := NULL;
      a_tab.DELETE;
      --
      --- 1o. Loop: Descobre as colunas e tipos
      ---           Guarda a definição da tabela e gera SELECT
      --
      FOR r_tab IN (SELECT column_id, column_name, data_type, data_length
                      FROM all_tab_columns
                     WHERE owner      = gvc_owner
                       AND table_name = pivc_table_name
                     ORDER BY column_id)
      LOOP
         IF gvc_header = 'S'
         THEN
            print( vc_sep || quote(r_tab.column_name) );
         END IF;
         --
         a_tab( r_tab.column_id ).col := r_tab.column_id;
         a_tab( r_tab.column_id ).typ := r_tab.data_type;
         a_tab( r_tab.column_id ).tam := r_tab.data_length;
         --
         vc_sql := vc_sql || vc_sep || r_tab.column_name;
         vc_sep := gvc_sep ;
         --
      END LOOP;
      --
      printl('');             -- fim da linha HEADER
      --
      vc_sql := '/* vc_sql */ select '|| vc_sql
                           || ' from '|| gvc_owner||'.'||pivc_table_name;
      --printl(vc_sql);
      sqlh := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE(sqlh, vc_sql, DBMS_SQL.V7);
      --
      ---  2o. Loop: Descobre tipo/Qte de variáveis para receber os valores
      --
      FOR i IN 1..a_tab.COUNT
      LOOP
         --
         IF    a_tab(i).typ = 'DATE' THEN
            DBMS_SQL.DEFINE_COLUMN(sqlh, i, a_tab(i).dt );
         ELSIF a_tab(i).typ = 'NUMBER' THEN
            DBMS_SQL.DEFINE_COLUMN(sqlh, i, a_tab(i).num );
         ELSIF a_tab(i).typ = 'LONG' THEN
            DBMS_SQL.DEFINE_COLUMN_LONG(sqlh, i );
         ELSE
            DBMS_SQL.DEFINE_COLUMN(sqlh, i, a_tab(i).vc, a_tab(i).tam );
         END IF;
         --
      END LOOP;
      --
      discard := DBMS_SQL.EXECUTE(sqlh);
      --
      --- 3o. Loop: externo - Para cada registro retornado...
      ---           interno - ...faz o "INTO" em cada variável
      --
      LOOP
         EXIT WHEN (DBMS_SQL.FETCH_ROWS(sqlh)=0);
         --
         vc_sep := NULL;   --- (!!!) o segredo da 1a. vírgula
         --
         FOR i IN 1..a_tab.COUNT
         LOOP
            --
            IF a_tab(i).typ = 'DATE'
            THEN
               DBMS_SQL.COLUMN_VALUE(sqlh, i, a_tab(i).dt );
               print( vc_sep||quote( TO_CHAR(a_tab(i).dt, 'dd/mm/yyyy hh24:mi:ss') ) );
            ELSIF a_tab(i).typ = 'NUMBER'
            THEN
               DBMS_SQL.COLUMN_VALUE(sqlh, i, a_tab(i).num );
               print( vc_sep||quote(TO_NUMBER(a_tab(i).num) ) );
            ELSIF a_tab(i).typ = 'LONG'
            THEN
               --
               --- LONG pode ter + de 4000 bytes: retorna blocks de 4000 e
               --- concatena
               --
               print( vc_sep || '"' );
               LOOP
                  DBMS_SQL.COLUMN_VALUE_LONG(sqlh, i, n_tam, n_pos, vc_long, n_bytes );
                  print( vc_long );
                  -- Há mais valores na coluna ?
                  IF SUBSTR( vc_long, 4000-5 ) IS NOT NULL
                  THEN
                     n_pos := n_pos + n_tam; -- SIM: busca próximo segmento
                  ELSE
                     end_of_long := TRUE;
                  END IF;
                  --
                  EXIT WHEN end_of_long;
                  --
               END LOOP;
               print( '"' );  -- fim do LONG
               --
            ELSE -- Varchar2 ???
               DBMS_SQL.COLUMN_VALUE(sqlh, i, a_tab(i).vc  );
               print( vc_sep||quote(a_tab(i).vc) );
            END IF;
            --
            vc_sep := gvc_sep;
            --
         END LOOP;
         --
         printl(''); -- fim da linha REGISTRO
         --
      END LOOP;
      --
      UTL_FILE.FCLOSE(fh);
      --
   EXCEPTION
      WHEN OTHERS THEN
         IF UTL_FILE.IS_OPEN(fh)
         THEN
            UTL_FILE.FCLOSE(fh);
         END IF;
         --
         DBMS_OUTPUT.PUT_LINE(SQLERRM);
         DBMS_OUTPUT.PUT_LINE('Comando: '||vc_sql);
         --
   END p_exp_loader;
   --
   -----
   --
BEGIN
   --
   DBMS_OUTPUT.PUT('Gerando &1');
   p_exp_loader( UPPER( NVL('&&1','DUAL') )
               , 'FORD'
               , '/traba/exp'
               );
   DBMS_OUTPUT.PUT_LINE(' ... OK');
   --
END;
/
