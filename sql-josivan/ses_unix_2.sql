/*
  script:   ses_unix_2.sql
  objetivo: Listar os processos no UNIX
  autor:    Josivan
  data:     
*/
col username format a10
--
select a.username
      ,a.machine
      ,a.terminal
      ,a.program
      ,b.spid
  from v$session a
      ,v$process b
 where a.paddr = b.addr
   and b.spid  = &1
/


//--------------------

  select decode(nvl(p.background, 0), 0, ' ', 'B') background
        ,to_number(p.SPID)           SPID
        ,'U:' || p.USERNAME          u_user
        ,'O:' || lower(s.USERNAME)   o_user
        ,p.TERMINAL
        ,upper(decode(nvl(s.command, 0),
                0,      '---------------',
                1,      'Create Table',
                2,      'Insert ...',
                3,      'Select ...',
                4,      'Create Cluster',
                5,      'Alter Cluster',
                6,      'Update ...',
                7,      'Delete ...',
                8,      'Drop ...',
                9,      'Create Index',
                10,     'Drop Index',
                11,     'Alter Index',
                12,     'Drop Table',
                13,     '--',
                14,     '--',
                15,     'Alter Table',
                16,     '--',
                17,     'Grant',
                18,     'Revoke',
                19,     'Create Synonym',
                20,     'Drop Synonym',
                21,     'Create View',
                22,     'Drop View',
                23,     '--',
                24,     '--',
                25,     '--',
                26,     'Lock Table',
                27,     'No Operation',
                28,     'Rename',
                29,     'Comment',
                30,     'Audit',
                31,     'NoAudit',
                32,     'Create Ext DB',
                33,     'Drop Ext. DB',
                34,     'Create Database',
                35,     'Alter Database',
                36,     'Create RBS',
                37,     'Alter RBS',
                38,     'Drop RBS',
                39,     'Create Tablespace',
                40,     'Alter Tablespace',
                41,     'Drop tablespace',
                42,     'Alter Session',
                43,     'Alter User',
                44,     'Commit',
                45,     'Rollback',
                46,     'Savepoint')) job
        ,s.program program
    from v$process p
        ,v$session s
   where p.addr=s.paddr (+)
     and p.spid is not null
order by 1
        ,program
        ,p.username
        ,s.username
        ,spid
/

