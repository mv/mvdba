Rem
Rem $Header: utlxplp.sql 05-jan-2000.22:11:51 bdagevil Exp $
Rem
Rem utlxplp.sql
Rem
Rem  Copyright (c) Oracle Corporation 1998, 2000. All Rights Reserved.
Rem
Rem    NAME
Rem      utlxplp.sql - UTiLity eXPLain Parallel plans
Rem
Rem    DESCRIPTION
Rem      script utility to display the explain plan of the last explain plan
Rem	 command. Display also Parallel Query information
Rem
Rem    NOTES
Rem      Assume that the table PLAN_TABLE has been created. The script 
Rem      utlxplan.sql should be used to create that table
Rem
Rem      To avoid lines from truncating or wrapping around:
Rem         'set charwidth 108' in svrmgrl
Rem	    'set linesize  108' in SQL*Plus
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    bdagevil    01/05/00 - make deterministic with order-by
Rem    bdagevil    05/07/98 - Explain plan script for parallel plans           
Rem    bdagevil    05/07/98 - Created
Rem


Rem
Rem Display last explain plan
Rem
select '| Operation                  |  Name    |  Rows | Bytes|  Cost  |  TQ  |IN-OUT| PQ Distrib | Pstart| Pstop |'  as "Plan Table" from dual
union all
select '------------------------------------------------------------------------------------------------------------' from dual
union all
select * from
(select /*+ no_merge */
       rpad('| '||substr(lpad(' ',1*(level-1))||operation||
            decode(options, null,'',' '||options), 1, 28), 29, ' ')||'|'||
       rpad(substr(object_name||' ',1, 9), 10, ' ')||'|'||
       lpad(decode(cardinality,null,'  ',
                decode(sign(cardinality-1000), -1, cardinality||' ', 
                decode(sign(cardinality-1000000), -1, trunc(cardinality/1000)||'K', 
                decode(sign(cardinality-1000000000), -1, trunc(cardinality/1000000)||'M', 
                       trunc(cardinality/1000000000)||'G')))), 7, ' ') || '|' ||
       lpad(decode(bytes,null,' ',
                decode(sign(bytes-1024), -1, bytes||' ', 
                decode(sign(bytes-1048576), -1, trunc(bytes/1024)||'K', 
                decode(sign(bytes-1073741824), -1, trunc(bytes/1048576)||'M', 
                       trunc(bytes/1073741824)||'G')))), 6, ' ') || '|' ||
       lpad(decode(cost,null,' ',
                decode(sign(cost-10000000), -1, cost||' ', 
                decode(sign(cost-1000000000), -1, trunc(cost/1000000)||'M', 
                       trunc(cost/1000000000)||'G'))), 8, ' ') || '|' ||
       lpad(decode(object_node,null,' ',
              substr(object_node,length(object_node)-3,1) || ',' || 
              substr(object_node,length(object_node)-1,2))||' ', 6, ' ') || '|' ||
       lpad(decode(other_tag, null,' ',
            decode(other_tag,'PARALLEL_TO_SERIAL', ' P->S', 
            decode(other_tag, 'PARALLEL_TO_PARALLEL', ' P->P', 
            decode(other_tag, 'PARALLEL_COMBINED_WITH_PARENT', ' PCWP', 
            decode(other_tag, 'PARALLEL_FROM_SERIAL', ' S->P', 
            decode(other_tag, 'PARALLEL_COMBINED_WITH_CHILD', ' PCWC', 
                   decode(other_tag,null,' ',other_tag)))))))||' ', 6, ' ') || '|' ||
       rpad(' '||decode(distribution, null,' ',
          decode(distribution, 'PARTITION (ROWID)', 'PART (RID)', 
          decode(distribution, 'PARTITION (KEY)', 'PART (KEY)', 
          decode(distribution, 'ROUND-ROBIN', 'RND-ROBIN', 
          decode(distribution, 'BROADCAST', 'BROADCAST', distribution))))), 12, ' ') || '|' ||
       lpad(decode(partition_start, 'ROW LOCATION', 'ROWID', 
            decode(partition_start, 'KEY', 'KEY', decode(partition_start, 
            'KEY(INLIST)', 'KEY(I)', decode(substr(partition_start, 1, 6), 
            'NUMBER', substr(substr(partition_start, 8, 10), 1, 
            length(substr(partition_start, 8, 10))-1), 
            decode(partition_start,null,' ',partition_start)))))||' ', 7, ' ')|| '|' ||
       lpad(decode(partition_stop, 'ROW LOCATION', 'ROW L', 
          decode(partition_stop, 'KEY', 'KEY', decode(partition_stop, 
          'KEY(INLIST)', 'KEY(I)', decode(substr(partition_stop, 1, 6), 
          'NUMBER', substr(substr(partition_stop, 8, 10), 1, 
          length(substr(partition_stop, 8, 10))-1), 
          decode(partition_stop,null,' ',partition_stop)))))||' ', 7, ' ')||'|' as "Explain plan"
from plan_table
start with id=0 and timestamp = (select max(timestamp) from plan_table 
                                 where id=0)
connect by prior id = parent_id 
        and prior nvl(statement_id, ' ') = nvl(statement_id, ' ')
        and prior timestamp <= timestamp
order by id, position)
union all
select '------------------------------------------------------------------------------------------------------------' from dual ;


