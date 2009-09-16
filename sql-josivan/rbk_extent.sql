rem 
rem  nome        : rbk_extent.sql
rem  objetivo    : Verificar numero de extensoes por segmento 
rem  uso         : sqlplus ou similar 
rem  limitacoes  : dba
rem 

rem
rem     Configurar Relatorio
rem
col p_temp1 new_value                   p_data      noprint
col p_temp2 new_value                   p_traco     noprint
col p_temp3 new_value                   p_database  noprint
col p_temp4 new_value                   p_spool     noprint
--
define p_sql       = rbk_extent
define p_titulo    = 'Verificar numero de extensoes por segmento '
define p_tam_linha = 95
--
set termout off
--
select lower(name)                     p_temp4
      ,lower(name)                     p_temp3
      ,to_char(sysdate,'YYYY-MM-DD')   p_temp1
      ,rpad('*', 95,'*')               p_temp2	
  from v$database
/

set termout on

rem
rem	Identificacao do relatorio
rem

clear screen
prompt
prompt Script : &&p_sql.
prompt Titulo : &&p_titulo.
prompt
prompt Spool  : &&p_spool.
prompt Report : &&p_tam_linha. colunas
prompt &&p_traco.
prompt 

rem
rem	Solicitacao de parametros
rem
accept p_qtd     prompt "Nr.ext.(extents > #) ? [50] "
accept p_linhas  prompt "Nr. de linhas....... ? [ 0] "
accept p_termout prompt "Termout (on/off).... ? [  ] "

rem
rem	Inicio do relatorio
rem

rem
rem	Configurar SQL*PLUS
rem
set pages &&p_linhas.
set lines &&p_tam_linha.
set verify off
set feedback off
set echo off
set termout &&p_termout.

clear screen

rem
rem	Header e Footer
rem
ttitle left p_traco skip -
       left p_data -
       right format 999 'Pag.: ' sql.pno skip 2 -
       center '&&p_titulo - (# > &&p_qtd)' skip 2 -
       left '&&p_sql' -
       right sql.user@&&p_database skip -
       left p_traco skip 2
btitle off

rem
rem	Quebra de pagina
rem
break on owner on segment_type

rem
rem	Definicao de colunas - Query 1
rem
col owner        format a10
col segment_type format a5  heading "Tipo"
col segment_name format a30 heading "Nome do Segmento"
col pct_increase format 999 heading "%|Inc"
col ini          format 9,999,999 heading "Initial|(Kb)"
col inc          format 9,999,999 heading "Next|(Kb)"
col tam          format 9,999,999 heading "Kbytes"
col ext                           heading "Extents|Qtd/Max"

rem
rem	Query 1
rem
  select owner
        ,segment_type
        ,segment_name
        ,initial_extent/1024 ini
        ,next_extent/1024    inc
        ,pct_increase
        ,lpad(replace(to_char(extents,'999')||'/'||to_char(max_extents,'999999'),' ',''),9) ext
        ,bytes/1024 tam
    from dba_segments
   where extents > decode('&&p_qtd','',50,'&&p_qtd')
order by owner
        ,segment_type desc
        ,extents desc
/

rem
rem	Fim do relatorio
rem
clear break
clear columns
clear compute
ttitle off
set termout on
set verify on
set feedback on
set echo on
