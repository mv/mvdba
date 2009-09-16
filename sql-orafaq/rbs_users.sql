REM  Users in rollback segments

REM  Users in rollback segments
REM
column rr heading 'RB Segment' format a18
column us heading 'Username' format a15
column os heading 'OS User' format a10
column te heading 'Terminal' format a10
select R.Name rr,
       nvl(S.Username,'no transaction') us,
       S.Osuser os,
       S.Terminal te
  from V$LOCK L, V$SESSION S, V$ROLLNAME R
 where L.Sid = S.Sid(+)
   and trunc(L.Id1/65536) = R.USN
   and L.Type = 'TX'
   and L.Lmode = 6
order by R.Name
/

