

CREATE OR REPLACE PACKAGE BODY monit AS
--
-- Based on: http://www.shutdownabort.com/scripts/oratop.php
--
-- Marcus Vinicius Ferreira                 ferreira.mv[ at ]gmail.com
-- 2009/Jun
--

    procedure oratop(hsize in number, vsize in number) is
    begin
        dbms_output.enable(9999999);

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
        dbms_output.put_line( 'SID/SER#  DB USER    OS USER    LASTCALL STATE    TERMINAL   COMMAND');
        dbms_output.put_line( '--------- ---------- ---------- -------- -------- ----------' || rpad(' ', hsize - 61, '-'));

        for x in (
            select *
              from (
                select to_char(sysdate - (last_call_et / 86400),'HH24:MI:SS')                       la
                     , to_char(LOGON_TIME                      ,'HH24:MI:SS')                       lt
                     , rpad(lower(status)                                            ,          9 ) st
                     , rpad(sid || ',' || serial#                                    ,         10 ) sid
                     , rpad(      substr(lower     (username)        , 1,         10),         10 ) usr
                     , rpad(  substr(nvl(lower     (osuser ) , 'n/a'), 1,         10),         10 ) osu
                     , rpad(  substr(nvl(lower(trim(program)), 'n/a'), 1, hsize - 62), hsize - 62 ) prg
                     , rpad(lower(decode(lower(trim(terminal))
                                        ,'unknown', substr( machine, 1, instr(machine, '.')-1 )
                                        , null, machine
                                        , terminal
                                        )
                                  )                                                  ,         20 ) mcn
                  from v$session sess
                 where username is not null
                 order by st
                        , ( select sum(value) from v$sesstat where statistic# in (12,40,43) and sid = sess.sid) desc
                        , la desc
              )
             where rownum < vsize - 7
        ) loop
            dbms_output.put_line(x.sid||x.usr||' '||x.osu||' '||x.la||' '||x.st||x.mcn||' '||x.prg);
        end loop;
        --
        dbms_output.put_line( chr(13) || chr(13) );
        --
    end oratop;
--
END monit;
/

