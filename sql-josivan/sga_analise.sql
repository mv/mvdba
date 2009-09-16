/*
  script:   sga_analise.sql
  objetivo: analise de memoria
  autor:    Josivan
  data:     

  V$SQLAREA         - COMANDOS,BLOCOS DE CODIGOS CONTIDOS NA SHARED SQL AREA/LIBRARY CACHE
  V$DB_OBJECT_CACHE - ESPACO OCUPADO NA LIBRARY CACHE POR COMANDOS E CODIGOS
  V$LIBRARYCACHE    - MONITORIZAR A MEMORIA LIBRARY CACHE / SHARED SQL AREA
  V$ROWCACHE        - MONITORIZAR A MEMORIA DATA DICTIONARY CACHE
  V$SYSSTAT         - MONITORIZAR A DATABASE BUFFER CACHE e REDO LOG BUFFER
  V$SESSTAT         - MONITORIZAR A DATABASE BUFFER CACHE POR SESSAO 
  V$STATNAME        - MONITORIZAR A DATABASE BUFFER CACHE POR SESSAO
  V$RECENT_BUCKET   - CONTEM UMA LINHA DE ESTATISTICAS POR CADA BUFFER ADICIONADO A BUFFER CACHE

*/

-------------------< MONITORIZAR A LIBRARY CACHE / SHARED SQL AREA >------------------------

--
-- percentual sobre os comando que estavam na LIBRARY CACHE e foram retirados por falta de 
-- espaco ( MISSES ) e voltaram a ser inseridos realizando todas operacoes
-- ( parse, plano e etc ) percentual minimo eh 99%
--
select sum(pins)                      "execucoes"
      ,sum(reloads)                   "misses"
      ,(100-(sum(reloads)/sum(pins))) "pin hit ratio"
 from v$librarycache
/ 

--
-- idem ao anterior
--
SELECT (SUM(RELOADS)/SUM(PINS)) * 100   "Falha SGA"
  FROM V$LIBRARYCACHE
/

--
-- indica o numero de vezes que determinado comando foi procurado na librarycache
-- e nao foi encontrado( SQL AREA ). deve ser mantida acima 90% se nao tiver a
-- reutilizacao de codigo PL/SQL por parte do desenvolvedores nao esta boa.
--
SELECT NAMESPACE
      ,ROUND(GETHITRATIO*100,2) "Get Hit Ratio"
  FROM V$LIBRARYCACHE
/


-------------------------< MONITORIZAR A DATA DICTIONARY CACHE >-------------------------------

--
-- a DATA DICTIONARY CACHE eh a memoria onde o oracle server utiliza para fazer
-- acessos para validacao do banco
-- percentual minimo aceitavel 85%
--
select sum(gets)        "Hits"
      ,sum(getmisses)   "Misses"
      ,round(((1-(sum(getmisses)/sum(gets)))*100),2)  "Get Hit Ratio(Data Dict Cache)"
  from v$rowcache
/

-------------------------< MONITORIZAR A DATA BASE BUFFER CACHE >------------------------------

-- as informacoes da buffer cache sao colhidas com base nas visoes V$SYSSTAT,V$SESSTAT que 
-- sao atualizadas apenas quando o parametro TIMED_STATISTICS=TRUE no INIT.ORA ou pode-se
-- habilitar colher as estatisticas e desabilitar atraves do comando de sistema:
-- ALTER SYSTEM SET TIMED_STATISTICS=TRUE/FALSE
-- 
-- a optimizacao desta area de memoria eh feita em duas perspectivas: ao nivel do sistema
-- e ao nivel da sessao. o objetivo eh melhorar o HIT RATIO total, no entanto eh possivel
-- determinar este indicador ao nivel da sessao.
-- o HIT RATIO global para funcionamento da BUFFER CACHE dever ter um minimo de 90%
--
-- NIVEL GLOBAL
--
select round(((1-(sum(decode(name,'physical reads',value,0))
       /(sum(decode(name,'db block gets',value,0))
       +(sum(decode(name,'consistent gets',value,0))))))*100),2) "Hit Ratio (Buffer Cache)"
  from v$sysstat
/

--
-- NIVEL DA SESSAO
--
   select s.sid
         ,e.username
         ,e.osuser
         ,round(((1-(sum(decode(name,'physical reads',value,0))
          /(sum(decode(name,'db block gets',value,1))
          +(sum(decode(name,'consistent gets',value,0))))))*100),2) "Hit Ratio (Sessao)"
     from v$session e
         ,v$sesstat  s
         ,v$statname t
    where e.sid        = s.sid
      and s.statistic# = t.statistic#
 group by s.sid
         ,e.username
         ,e.osuser
/

--
-- qual o valor ideal para o parametro DB_BLOCK_BUFFERS
-- as funcoes abaixo faz um estudo do impacto desses valores
-- criar/executar as funcoes como SYS e criar a tabela com outro usuario e dar acesso ao SYS
-- o parametro DB_BLOCK_LRU_EXTENDED_STATISTICS=500 pois o default eh zero, isto habilitara as
-- estatisticas da visao v$recent_bucket ( V_$RECENT_BUCKET ) que contem uma linha para cada
-- buffer adicionado na memoria buffer cache
--
create or replace function ADD_BUFS( p_indx  number := 0 ) return number is
cursor c2 is
  select 1,sum(count) count
    from v_$recent_bucket
   where rownum <= p_indx
group by 1;

retval    number := 0;
rc_c2     c2%rowtype;

begin
  if p_indx > 0 then
     open c2;
     fetch c2 into rc_c2;
     retval := rc_c2.count;
     close c2;
  end if;
  return( retval );
end;
/

create or replace function ADD_BUFS_IMPACT( p_buf  number ) return number is
cursor c1(buf number) is
  select round(((1-(sum(decode(name,'physical reads',value-nvl(buf,0),0))
         / (sum(decode(name,'db block gets',value,0))
         + (sum(decode(name,'consistent gets',value,0))) )))*100),2)
    from v$sysstat;

c_buff   number := ADD_BUFS(p_buf);
retval   number := 0;

begin
  open c1(c_buff);
  fetch c1 into retval;
  close c1;
  return(retval);
end;
/

procedimento
------------
1-tamanho da buffer cache neste momento em blocos
  x=db_block_buffers
2-create table teste( bufs number );
3-incluir valores de 50 em 50 ate o limite de 500
  begin
    for i in 1..10 loop 
      insert into teste values(i*50);
    end loop;
    commit;
  end loop;
4-calcular o hit ratio da buffer cache neste momento
5-analise do impacto com novos blocos

  select x+bufs                "DB_BLOCK_BUFFERS"
        ,add_bufs_impact(bufs) "Hit Ratio"
    from teste
order by 1;



-----------------------< MONITORIZAR A REDO LOG BUFFER >---------------------------------------

--
-- a redo log buffer eh a menor memoria da SGA, o seu tamanho eh determinado pelo parametro
-- LOG_BUFFER. a informacao que esta memoria nos passa sao entradas de log. essas entradas
-- sao escritas pelo SERVER PROCESS de cada sessao e sao necessarias para reconstruir as 
-- alteracoes feitas a base de dados, incluindo transacoes nao confirmadas. se o LGWR demora a
-- libertar espaco e sinal que demora a escrever os conteudos do redo log buffer em memoria ou
-- entao que o espaco deste buffer eh muito pequeno para todos os pedidos que recebe.
-- o indicador de performace da redo log buffer eh dado pelo grau de contencao nos acessos
-- a esta area da SGA. eh obtido pela vista V$SYSSTAT nas estatisticas:
   .redo log space requests
   .redo log space wait time
-- a primeira mostra o numero de vezes que um server process teve de esperar por espaco na
-- redo log buffer ao passo que a segunda mostra o tempo em centesimos de segundo que foi
-- gasto neste genero de esperas. o grau de contencao nao pode ser maior que 5 entradas

--
-- GRAU DE CONTENCAO
--
select round(100*sum(decode(name,'redo log space requests',value,0)) /
       sum(decode(name,'redo entries',value,0)),2) "Grau de Contencao"
  from v$sysstat
/

-----------------------------< OPTIMIZAR O LGWR >----------------------------------------------

--
-- o processo LGWR nao pode ser mais rapido que o processo ARCH, pois se isto acontece o
-- LGWR tem de ficar a esperar que o ARCH termine. O processo ARCH eh o unico que escreve
-- e lê. le os redo logs e escreve nos archive logs. ( alias cria-os ) e ainda no controlfile.
-- o disco para onde o LGWR esta a escrever o conteudo de memoria nao deve ser o mesmo de onde 
-- o processo ARCH esta a ler/escrever o grupo anterior.
--
1- separar redo logfiles no caso da base de dados em archivelog
2- separar sempre os membros do mesmo grupo de redo logfiles
3- separar sempre os archive logs dos redo logfiles

se houver estrangulamento de i/o ou se o sistema nao suportar operacoes assincronas dever
utilizar os parametros:

  LGWR_IO_SLAVES
  ARCH_IO_SLAVES


-----------------------------< OPTIMIZAR O DBWR >----------------------------------------------

--
-- optimizar os dbwr significa tornar mais eficaz as suas operacoes de escrita, para existe 
-- duas formas:

   DBWR_IO_SLAVES
   DB_FILE_SIMULTANEOUS_WRITES

-- no primeiro serao lancados o numero de processos dedicados a operacoes de i/o que for
-- colocado neste parametro, alem do DBWR continuar a efetuar as suas tarefas hatibutais de
-- manutencao da database buffer cache. este parametro deve apenas ser modificado quando
-- a carga transacional for muito elevada.
-- o segundo parametro estabelece o numero maximo de processo que podem escrever num ficheiro
-- simultaneamente. o valor pre-definido eh 4. 
-- para saber qual a eficacia das variacoes neste parametro dever usado o script abaixo:
-- 
select average_wait
  from v$system_event
 where event = 'write complete waits'
/

-----------------------------< OPTIMIZAR O CKPT >----------------------------------------------

--
-- um checkpoint eh o instante em que o processo DBWR escreve nos datafiles o conteudo da 
-- database buffer cache. o checkpoint acontece num dos tres momentos:
--
1-forcado por um parametro regulado pelo DBA
2-forcado explicitamente pelo DBA atraves de um comando ( ALTER SYSTEM CHECKPOINT )
3-quando o processo LGWR muda de grupo de log ( logswitch )

-- existem 3 formas de influenciar diretamente a frequencia dos checkpoints:

   LOG_CHECKPOINT_INTERVAL
   LOG_CHECKPOINT_TIMEOUT
   ALTER SYSTEM

-- o primeiro parametro eh dificil ser dimensionado uma vez que se mede em numero de blocos
-- do sistema operacional que ja foram escrito em log. eh aconselhado deixar zero
-- o segundo permite influenciar o intervalo temporal que separa os checkpoints e eh medido
-- em segundos.
-- por ultimo o DBA podera fazer diretamento atraves do: ALTER SYSTEM CHECKPOINT;

-- o objetivo da optimizacao dos checkpoints tambem sao:

   regular o tamanho dos logfiles
   regular o parametro DB_BLOCK_CHECKPOINT_BATCH

no primeiro se o tamanho dos logfiles for muito pequeno o lgwr vai demorar pouco tempo
entre as trocas de grupo de logs. como eh forcado um checkpoint sempre que se da esta troca
pode nao haver tempo suficiente entre um logswitch e outro para que seja feitas as escritas
preconizadas pelo checkpoint. dbwr escreve blocos dirty e ckpt atualiza o SCN no cabecalho
dos datafiles. se isto acontecer entao o alert.log tera a mensagem "checkpoint not complete"
este eh um sintoma claro de que o tamanho dos logfiles e desproporcionalmente pequeno face 
as exigencias do sistema.

o segundo parametro permite regualar a parte dos acessos feitos durante um checkpoint que
se destina a atualizacao dos cabecalhos dos ficheiros. este parametro indica quantos
blocos sao destinados a este tipo de escritas, quando ocorre um checkpoint. se for colocado
um valor pequeno pode melhorar o impacto dos checkpoint evitando um maior volume de acessos.
todavia essa medida pode atrasar os checkpoint e volta a acontecer o problema do paragrafo
anterior. se for aumentado entao os checkpoints irao terminar mais rapidamente, mas sera
sacrificado o desempenho do i/o. o valor pre-definido eh 8 blocos.

-----------------------------< OUTRAS ESTATISTICAS  >------------------------------------------

--
-- I/O datafiles
--
column name format a45 
--
  select substr(name,1,40)
        ,phyrds
        ,phywrts
    from v$datafile df
        ,v$filestat fs
   where df.file#=fs.file# 
order by 1
/


select name
      ,value
  from v$sysstat
 where name = 'recursive calls'
/



--
-- CONTENTION
--
select class
      ,count
  from v$waitstat
 where class in ( 'system undo header'
                 ,'system undo block'
                 ,'undo header'
                 ,'undo block')
/ 

select sum(value)
  from v$sysstat
 where name in ( 'db block gets'
                ,'consistent gets')
/


select name
      ,value
  from v$sysstat
 where name in ( 'sorts (memory)'
                ,'sorts (disk)')
/
 
select class
      ,count
  from v$waitstat
 where class = 'free list'
/

--
-- DISK SPACE  
--
  select tablespace_name
        ,sum(bytes)/1024/1024
    from dba_free_space
group by tablespace_name
/


  select tablespace_name
        ,bytes / 1024 / 1024
    from dba_free_space
order by 1,2
/


--
-- FRAGMENTACAO  
--
column segment_name format a30 
column owner format a10
--
  select owner
        ,segment_name
        ,extents
    from dba_segments
   where owner not like '%SYS%'
     and extents > 5
order by 1,3
/



  select decode(state,0,'Free'
                       ,1,'Read and Modified'
                       ,2,'Read and Not Modified'
                       ,3,'Currently Being Read'
                         ,'Other')
        ,count(*)
    from x$bh
group by decode (state,0,'Free'
                      ,1,'Read and Modified'
                      ,2,'Read and Not Modified'
                      ,3,'Currently Being Read'
                        ,'Other')
/
