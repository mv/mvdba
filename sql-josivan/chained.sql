/*

  resolvendo o problema de CHAINED e MIGRATION

*/

1-atualizar as estatisticas dos objectos da base de dados 

  ANALYZE TABLE TRANS_ABAST COMPUTE/ESTIMATE STATISTICS SAMPLE 20

2-detectar as tabelas que tem chaining ou migration 

  SELECT TABLE_NAME 
    FROM DBA_TABLES 
   WHERE OWNER='GALPDBA'
     AND CHAIN_CNT IS NOT NULL

3-RODAR O SCRIPT ULTCHAIN.SQL SOB O SCHEMA SYSTEM
4-ANALISAR A TABELA

  ANALYZE TABLE CHAINED_ROWS LIST CHAINED ROWS

5-a coluna HEAD_ROWID mostra quais as linhas estao migradas ou partidas e
  para resolver o problema basta apagalas e inseri-las novamente.

  5.1- a tabela trans_abast esta com linhas chained, primeiro vamos criar uma
       tabela temporaria com as linhas chaining.

  create table trans_abast_tmp as
  select * 
    from trans_abast
   where rowid in ( select head_rowid 
                      from chained_rows );

   5.2- apagar as linhas chained na tabela original

   delete from table trans_abast where rowid in ( select head_rowid from chained_rows );

   5.3- tornar a inserir as linhas que estao na tabela temporaria

   insert into trans_abast ( select * from trans_abast_tmp );

   5.4- apagar a tabela temporaria

   drop table trans_abast;




  