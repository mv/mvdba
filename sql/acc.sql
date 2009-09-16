column object format a30
column owner  format a20
select * from v$access
 where object like nvl('&1','%')
order by owner,object
/
