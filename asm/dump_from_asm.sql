
-- Ref: http://www.freelists.org/post/oracle-l/ASM-is-single-point-of-failure,17

select 'dd if='|| d.path||' bs=1048576 skip='||AU_KFFXP||' count=1 '
    || '>> /tmp/'||substr('&1',instr('&1','/',-1)+1)||'.dmp'  cmd
  from X$KFFXP X
     , V$ASM_DISK D
     , V$ASM_ALIAS A
 where lower(A.NAME)  = lower(substr('&1',instr('&1','/',-1)+1))
   and X.NUMBER_KFFXP = A.FILE_NUMBER
   and X.GROUP_KFFXP  = A.GROUP_NUMBER
   and X.INCARN_KFFXP = A.FILE_INCARNATION
   and X.DISK_KFFXP   = D.DISK_NUMBER
   and X.GROUP_KFFXP  = D.GROUP_NUMBER
 order by X.XNUM_KFFXP
     ;



-- Ref: http://www.freelists.org/post/oracle-l/ASM-is-single-point-of-failure,22

-- simple asm dump utility
-- use full database file name (with +datagroup name) as only parameter
-- nb! doesnt work properly on multidisk diskgroups with fine grained striping
-- single disk disk groups with fine grained striping or multidisk groups
-- with coarse grained striping are ok
--
-- tanel poder - nov 2005 [ http://www.tanelpoder.com ]
-- L.C.- May 2006, modified and tested on Linux + 10gR2 + asmlib + ASM mirroring

set lines 300 trim on verify off pages 50000

select 'dd if='|| replace(path,'ORCL:','/dev/oracleasm/disks/')||' bs=1048576 skip='||AU_KFFXP||' count=1 '
    || '>> /tmp/'||substr('&1',instr('&1','/',-1)+1)||'.dmp'  cmd
  from X$KFFXP X
     , V$ASM_DISK_STAT D
     , V$ASM_ALIAS A
 where lower(A.NAME) = lower(substr('&1',instr('&1','/',-1)+1))
    and X.NUMBER_KFFXP = A.FILE_NUMBER
    and X.GROUP_KFFXP  = A.GROUP_NUMBER
    and X.INCARN_KFFXP = A.FILE_INCARNATION
    and X.DISK_KFFXP = D.DISK_NUMBER
    and X.GROUP_KFFXP = D.GROUP_NUMBER
    and LXN_KFFXP = 0
   order by X.XNUM_KFFXP; 

