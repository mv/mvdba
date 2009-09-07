CREATE OR REPLACE PACKAGE BODY monit AS
--
-- Based on: http://www.shutdownabort.com/scripts/oratop.php
--
-- Pre-req:
--     sys:
--         grant select on v_$instance to public;
--         grant select on v_$session  to public;
--         grant select on v_$sesstat  to public;
--         grant select on v_$process  to public;
--
-- Post:
--     system:
--         grant execute on monit to public;
--
-- Marcus Vinicius Ferreira                 ferreira.mv[ at ]gmail.com
-- 2009/Jun
--
    g_hsize NUMBER;
    --
    procedure p( msg in varchar2) is
    begin
        dbms_output.put_line( substr(msg, 1, g_hsize) );
    end p;
    --
    -----
    --
    function perc_longops( p_sid in number,  p_serial# in number) return varchar2 is
    begin
        for r in (
                select sofar
                     , totalwork
                     , round(sofar/totalwork * 100, 2) perc
                  from v$session_longops
                 where sid     = p_sid
                   and serial# = p_serial#
                   and NVL(totalwork,0) > 0
            )
        loop
            if r.perc < 100
            then return( to_char(r.perc, '999d00') ||'%');
            end if;
        end loop;

        RETURN( '-' );
    end perc_longops;
    --
    -----
    --
    procedure oratop(hsize in number, vsize in number) is
    begin
        dbms_output.enable(9999999);
        g_hsize := hsize;

        for a in (
            select rpad(host_name      , hsize - 40)             host_name
                 , rpad(instance_name  , hsize - 49)             instance_name
                 , to_char(sysdate     , 'HH24:MI:SS DD-MON-YY') currtime
                 , to_char(startup_time, 'HH24:MI:SS DD-MON-YY') starttime
              from v$instance
        ) loop
            dbms_output.put_line('System: '   || a.host_name     || 'System time: '        || a.currtime  );
            dbms_output.put_line('Instance: ' || a.instance_name || 'Inst start-up time: ' || a.starttime );
        end loop;

        for b in (
            select total, active, inactive, system, killed
            from (select count(*) total    from v$session                                                 )
               , (select count(*) system   from v$session where username is null                          )
               , (select count(*) active   from v$session where status = 'ACTIVE' and username is not null)
               , (select count(*) inactive from v$session where status = 'INACTIVE'                       )
               , (select count(*) killed   from v$session where status = 'KILLED'                         )
        ) loop
            dbms_output.put_line( b.total    || ' sessions: '
                               || b.inactive || ' inactive, '
                               || b.active   || ' active, '
                               || b.system   || ' system, '
                               || b.killed   || ' killed'
                               );
        end loop;

        dbms_output.put_line( chr(13) );
        p( 'SID,SERIAL DB USER    OSPID  OS USER    LOGON SINCE         STATE    MACHINE         COMMAND          MODULE           ACTION     LONGOPS?');
        p( '---------- ---------- ------ ---------- ------------------- -------- --------------- ---------------- ---------------- ---------- --------');

        for x in (
            select *
              from ( -- backup full dat
                select s.sid, s.serial#
                     , lower(s.username)                                        usr
                     , to_char(sysdate - (s.last_call_et / 86400),'HH24:MI:SS') la
                     , to_char(s.logon_time                      ,'YYYY-MM-DD HH24:MI:SS') lt
                     ,   lower(s.status)                                        st
                     , to_char(p.spid, 99999 )                                  pid
                     ,  lower( nvl(     s.osuser   , 'n/a') )                   osu
                     ,  lower( nvl(trim(s.program) , 'n/a') )                   cmd
                     ,  lower(decode(nvl(s.terminal, 'n/a') ,'n/a', s.machine
                                                            , s.terminal
                                                            ))                  mcn
                     ,  substr(lower( nvl(module, ' ')), 1, 16)                 mdl
                     ,  substr(lower( nvl(action, ' ')), 1, 10)                 act
                  from v$session s
                     , v$process p
                 where s.username is not null
                   and s.paddr = p.addr(+)
                 order by st
                        , ( select sum(value) from v$sesstat ss where ss.statistic# in (12,40,43) and ss.sid = s.sid) desc
                        , la desc
              )
             where rownum < vsize - 10
        ) loop
            p( rpad(x.sid ||','|| x.serial# , 11 )
             ||rpad(x.usr                   , 11 )
             ||rpad(x.pid                   ,  7 )
             ||rpad(x.osu                   , 11 )
          -- ||rpad(x.la                    ,  9 )
             ||rpad(x.lt                    , 20 )
             ||rpad(x.st                    ,  9 )
             ||rpad(x.mcn                   , 16 )
             ||rpad(x.cmd                   , 16 )||' '
             ||rpad(x.mdl                   , 16 )||' '
             ||rpad(x.act                   , 10 )||' '
             ||lpad(perc_longops( x.sid, x.serial# ), 8)
              );
                 --  , rpad(  substr(nvl(lower(trim(s.program)), 'n/a'), 1, hsize - 62), hsize - 62 ) prg -- 8: command
        end loop;
        --
        dbms_output.put_line( chr(13) || chr(13) );
        --
    end oratop;
--
END monit;
/

show errors


