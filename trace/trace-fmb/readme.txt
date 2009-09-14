What: Habilitando trace no forms.
When: Dez/2007
Who:  Marcus Vinicius Ferreira      ferreira.mv[ at ]gmail.com

Forms Trace
===========

Instruções
----------

1 - Criar tabela acessória.

    A partir do script trace_form.sql, criar a tabela, uma trigger,
    e a pk necessárias.

    ___________________________________________________________
    trace_forms.sql:

        -- DROP TABLE trace_form;

        CREATE TABLE trace_form
        ( form_name     VARCHAR2(60)
        , trace_enable  CHAR(1)     DEFAULT 'N'
        );

        ALTER TABLE trace_form
            ADD CONSTRAINT pk_trace_form PRIMARY KEY (form_name);

        ALTER TABLE trace_form
            ADD CONSTRAINT ck_trace_form CHECK (trace_enable IN ('Y','N'));

        CREATE OR REPLACE TRIGGER tr_trace_form_biu
                           BEFORE INSERT
                               OR UPDATE
                               ON trace_form
                              FOR EACH ROW
        BEGIN
            :NEW.trace_enable := UPPER(:NEW.trace_enable);
        END;
        /
    ___________________________________________________________

    Observação:

    Se houver mais de um schema/usuário/aplicação na base, é recomendado
    não esquece de criar um SYNONYM e dar o grant de SELECT para que
    cada schema da base possa enxergar uma única tabela de controle.


2 - Dar direito de "ALTER SESSION" aos usuários de banco que irão
    operar os FORMS.

    Para cada usuário/schema que é usando para fazer login nos forms,
    executar com o usuário SYSTEM:

    SQL> GRANT ALTER SESSION TO user1,user2,user3;

    Outra maneira, mais global, é simplesmente fazer:

    SQL> GRANT ALTER SESSION TO CONNECT;

    Assim, qualquer usuárioi já definido com a role CONNECT terá
    "ALTER SESSION" disponibilizado.

3 - Criar a pll TRACE.pll

    A pll deve ser criada e disponibilizada em qualquer diretório
    que já esteja definido na variável FORMSxx_PATH. Se esse
    diretório não estiver na variável, que seja incluído no
    FORMSxx_PATH de cada cliente que rodará o FORMS.

    As procedures que ativam trace para a sessão são:

    -+ TRACE_BEGIN
     |  +- EXECUTE_IMMEDIATE
     +- TRACE_END
     +- TRACE_FORM

     O código de cada procedure deve ser:

    ___________________________________________________________
    Program Unit:

        PROCEDURE execute_immediate (sql_text IN VARCHAR2) IS
            ch      INTEGER;
            res     INTEGER;
        BEGIN
            ch  := DBMS_SQL.OPEN_CURSOR;
            DBMS_SQL.PARSE(ch, sql_text, 2);
            res := DBMS_SQL.EXECUTE(ch);
            DBMS_SQL.CLOSE_CURSOR(ch);
            --
            MESSAGE('Executed: '||sql_text, NO_ACKNOWLEDGE);
            --
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_SQL.CLOSE_CURSOR(ch);
                MESSAGE('Error: ['||sql_text||'], NO_ACKNOWLEDGE);
        END;
    ___________________________________________________________
    Program Unit:

        PROCEDURE trace_begin IS
                form_name           VARCHAR2(40);
                exec_name           VARCHAR2(40);
        BEGIN
              --
              form_name := CHR(39)||LOWER( GET_APPLICATION_PROPERTY( current_form_name ))||CHR(39) ;
              message('Form '||form_name , NO_ACKNOWLEDGE);

         -- exec_name := GET_APPLICATION_PROPERTY( current_form      );
         -- message('Exec '||exec_name , NO_ACKNOWLEDGE);

            execute_immediate('alter session set max_dump_file_size=unlimited');
            execute_immediate('alter session set timed_statistics=TRUE');
            execute_immediate('alter session set tracefile_identifier='||form_name );
            execute_immediate('alter session set events '||CHR(39)||'10046 trace name context forever, level 12'||CHR(39));

        END;
    ___________________________________________________________
    Program Unit:

        PROCEDURE trace_end IS
        BEGIN
            dbms_session.set_sql_trace(FALSE);
        END;
    ___________________________________________________________
    Program Unit:

        PROCEDURE TRACE_FORM IS
                module_name VARCHAR2(40) := GET_APPLICATION_PROPERTY( current_form_name );
        BEGIN
            FOR r1 IN (SELECT trace_enable
                         FROM trace_form
                        WHERE form_name = module_name)
            LOOP
                    IF r1.trace_enable = 'Y'
                    THEN
                        trace_begin;
                    END IF;
            END LOOP;
            --
        END;
    ___________________________________________________________



4 - Ajustar cada FORM que sofrerá TRACE:

    a) Anexar a pll TRACE.pll no form. Vide a figura
       obj_navigator.png como exemplo.

    b) Incluir/Ajustar as triggers do form:

    ___________________________________________________________
    WHEN-NEW-FORM-INSTANCE:

        DBMS_APPLICATION_INFO.SET_MODULE( GET_APPLICATION_PROPERTY(current_form_name)
                                        , :SYSTEM.CURRENT_BLOCK
                                        );
        trace_form;

    ___________________________________________________________

    ___________________________________________________________
    KEY-EXIT:

        dbms_session.set_sql_trace(FALSE);
        EXIT_FORM;
    ___________________________________________________________


5 - Cadastra o FORM que sofrerá TRACE na tabela "trace_form":

    ___________________________________________________________

        SQL> INSERT INTO trace_form VALUES('EMP1','Y');
        SQL> COMMIT;
    ___________________________________________________________


Observação:

    O ideal é controlar o TRACE de cada form globalmente, usando
    a tabela de cadastro. Opcionalmente, seria possível ativar o
    trace por iniciativa do usuário, criando-se um botão a mais
    no form e/ou fazendo-se um item de menu (um menu global seria
    ideal). Em cada um desses, bastaria acrescentar:

    ___________________________________________________________
    WHEN-BUTTON-PRESSED:

        -- Ativa trace
        trace_form;
    ___________________________________________________________


6 - Capturar as informações

    Para cada form com problema, a coluna TRACE_ENABLE da tabela
    de controle/cadastro deve estar previamente com o valor 'Y'.

    Quando houver um evento de LOCK ou lentidão que seja interessante
    investigar, as seguintes informações devem ser coletadas ANTES
    de se matar a sessão com problemas:

    - INSTANCE_ID onde a sessão está travada
    - SESSION_ID da sessão que travou
    - SESSION_ID de qualquer outra sessão que está na fila de
      travamento.

    Exemplo, a partir do Enterprise Manager Grid:
    ___________________________________________________________

        Lock:

            7654
              +- 8192
              +- 9022
              +- 9456
    ___________________________________________________________

    Nesse caso, anotar:

        - Instance_id da sessão travada.
        - sessão travada: 7654
        - sessões em espera: 8192, 9022

    A partir desses valores, será possível obter do diretório
    'cdump' do nó "instace_id" os seguintes arquivos:
        - paz_ora_7654_<form>.trc
        - paz_ora_9022_<form>.trc
        - paz_ora_9456_<form>.trc



.
