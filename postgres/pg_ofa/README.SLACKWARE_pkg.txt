$Id: README.SLACKWARE_pkg.txt 6 2006-09-10 15:35:16Z marcus $


Postgres SLACKWARE package
--------------------------


1) Compilar a distribuicao de Postgres

   vide build_pg_ofa.txt

2) Criar diretorio de trabalho

    Ex: slackpack/pkg/pg-version

3) Dentro do diretorio de trabalhar criar a arvore

    etc/skel
    etc/profile.d
    export/home/postgres/bin
    install
    u01/app/postgres/admin
                     cron.d
                     product/7.4.7
    u01/pgdata/log

4) Editar /etc/profile.d/postgres.sh

    Colocar a versao correta do release

5) Editar install/slack-desc

    Colocar a versao correta do release

6) Editar doinst.sh

    Ajustar a nova árvore na secao "GENERATED"

7) Copiar a arvore dos binarios criada

    /u01/app/postgres   ->  slackpack/pkg/pg-version/u01/app/postgres
    /u01/pgdata         ->  slackpack/pkg/pg-version/u01/pgdata

8) Corrigir Permissoes

    chown -R postgres:postgres slackpack/pkg/pg-version/u01

9) Executar makepkg.sh

10) Ver scripts de startup

