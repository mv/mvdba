DECLARE
   --
   ---- para STORED PROCEDURE: retirar DECLARE e bloco anônimo ao final
   --
   PROCEDURE p_exp_loader_ctl( pivc_table_name IN VARCHAR2
                             , pivc_owner      IN VARCHAR2 DEFAULT NULL
                             , pivc_path       IN VARCHAR2 DEFAULT NULL
                             , pivc_sep        IN VARCHAR2 DEFAULT NULL) IS
   ----------------
   --  p_exp_loader_ctl: gera o control file do SQL*Loader a partir de uma tabela
   --
   --  HISTORY
   --     11/Ago/2000 - Marcus Vinicius Ferreira - Criação
   --
      -- Arquivo
         fh          UTL_FILE.FILE_TYPE;
         vc_file     VARCHAR2(255);
         vc_sep      CHAR(1);
         gvc_owner   VARCHAR2(30);        -- schema
         gvc_path    VARCHAR2(255):= NVL(pivc_path, '/traba/exp');
         gvc_sep     VARCHAR2(1)  := NVL(pivc_sep , ',');  -- separador
      --
      --- print: concatena
      PROCEDURE print (pivc_valor IN VARCHAR2) IS
      BEGIN
         UTL_FILE.PUT(fh, pivc_valor);
         DBMS_OUTPUT.PUT(pivc_valor);
      END print;
      --
      --- printl: quebra a linha
      PROCEDURE printl(pivc_valor IN VARCHAR2) IS
      BEGIN
         UTL_FILE.PUT_LINE(fh, pivc_valor);
         DBMS_OUTPUT.PUT_LINE(pivc_valor);
      END printl;
      --
   BEGIN
      --
      --- Arquivo
      --
      IF pivc_owner IS NOT NULL
      THEN
         gvc_owner := pivc_owner || '_';
      END IF;
      --
      vc_file := LOWER(gvc_owner)||LOWER(pivc_table_name);
      --
      fh := UTL_FILE.FOPEN(gvc_path
                          ,vc_file||'.ctl'
                          ,'W');
      --
      printl('LOAD DATA');
      printl('INFILE      '||vc_file||'.dat');
      printl('BADFILE     '||vc_file||'.bad');
      printl('DISCARDFILE '||vc_file||'.dsc');
      printl('INSERT');
      printl('INTO TABLE  '||REPLACE(pivc_table_name,'_','.') );
      print ('FIELDS TERMINATED BY   '||CHR(39)||gvc_sep||CHR(39)||'  ');
      printl('OPTIONALLY ENCLOSED BY '||CHR(39)||  '"'  ||CHR(39)||'  ');
      --
      vc_sep  := '( ';
      --
      --- 1o. Loop: Descobre as colunas e tipos
      --
      FOR r_tab IN (SELECT column_id, column_name, data_type, data_precision, data_scale
                      FROM all_tab_columns
                     WHERE owner      = pivc_owner
                       AND table_name = pivc_table_name
                     ORDER BY column_id
                    )
      LOOP
         --
         print ( vc_sep || RPAD(r_tab.column_name, 30, ' ') );
         IF    r_tab.data_type = 'DATE'
         THEN
            print ('DATE "dd/mm/yyyy hh24:mi:ss"');
         ELSIF r_tab.data_type = 'NUMBER'
         THEN
            print ('DECIMAL EXTERNAL');
         ELSE
            print ('CHAR');
         END IF;
         --
         printl( '  NULLIF '||r_tab.column_name||' = BLANKS ');
         --
         vc_sep := gvc_sep ;
         --
      END LOOP;
      --
      printl(')');             -- fim da linha
      printl('');
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
         --
   END p_exp_loader_ctl;
   --
   -----
   --
BEGIN
   --
   DBMS_OUTPUT.PUT('Gerando &1');
   p_exp_loader_ctl( UPPER( NVL('&&1','DUAL') )
                   , 'FORD'
                   , '/traba/exp'
                   );
   DBMS_OUTPUT.PUT_LINE(' ... OK');
   --
END;
/
