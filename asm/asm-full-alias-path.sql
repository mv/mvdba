SELECT concat('+' || gname, sys_connect_by_path(aname, '/')) full_alias_path
  FROM (SELECT g.NAME            gname
             , a.parent_index    pindex
             , a.NAME            aname
             , a.reference_index rindex
          FROM v$asm_alias     a
             , v$asm_diskgroup g
         WHERE a.group_number = g.group_number
        )
 START WITH (MOD(pindex, power(2, 24))) = 0
CONNECT BY PRIOR rindex = pindex;