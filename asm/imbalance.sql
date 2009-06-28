-- Ref: https://metalink2.oracle.com/metalink/plsql/f?p=130:3:8227951168393627762::::p3_database_id,p3_docid,p3_black_frame,P3_SHOW_HEADER,p3_show_help:NOT,367445.1,0,0,0
--      metalink 367445.1
/*
 * RUN THIS SQL*PLUS SCRIPT WHILE CONNECTED TO AN ASM INSTANCE WITH
 * DISKGROUPS MOUNTED. "no rows selected" IF NO DISKGROUPS ARE MOUNTED
 */
set verify off
clear columns

/* THE FOLLOWING ERROR WILL BE REPORTED IF THIS SCRIPT IS RUN ON 10gR1

ORA-01219: database not open: queries allowed on fixed tables/views only

 * This script is intended to work with 10gR2 and later. To make it work with
 * 10gR1 you must remove the "_stat" in the following two defines by
 * uncommenting the redefines that follow. The _stat tables eliminate disk
 * header reads, but they were not available in 10.1
 */
define asm_disk = v$asm_disk_stat
define asm_diskgroup = v$asm_diskgroup_stat
/* for 10.1 uncomment the following redefines
/* define asm_disk = v$asm_disk
/* define asm_diskgroup = v$asm_diskgroup
*/

/*
 * Query to see if any diskgroups are out of balance
 */
column "Diskgroup" format A30
column "Diskgroup" Heading " Columns Described in Script||Diskgroup Name"

/*
 * The imbalance measures the difference in space allocated to the fullest and
 * emptiest disks in the disk group. Comparision is in percent full since ASM
 * tries to keep all disks equally full as a percent of their size. The
 * imbalance is relative to the space allocated not the space available. An
 * imbalance of a couple percent is reasonable
 */
column  "Imbalance" format 99.9 Heading "Percent|Imbalance"


/*
 * Percent disk size varience gives the percentage difference in size between
 * the largest and smallest disks in the disk group. This will be zero if
 * best practices have been followed and all disks are the same size. Small
 * differences in size are acceptible. Large differences can result in some
 * disks getting much more I/O than others. With normal or high redundancy
 * diskgroups a large size varience can make it impossible to reduce the
 * percent imbalance to a small value.
 */
column  "Varience" format 99.9 Heading "Percent|Disk Size|Varience"

/*
 * Minimum percent free gives the amount of free disk space on the fullest
 * disk as a percent of the disk size. If the imbalance is zero then this
 * represents the total freespace. Since all allocations are done evenly
 * across all disks, the minimum free space limits how much space can be
 * used. If one disk has only one percent free, then only one percent of the
 * space in the diskgroup is really available for allocation, even if the
 * rest of the disks are only half full.
 */
column  "MinFree" format 99.9 Heading "Minimum|Percent|Free"

/*
 * The number of disks in the disk group gives a sense of how widely the
 * files can be spread.
 */
column "DiskCnt" format 9999 Heading "Disk|Count"

/*
 * External redundancy diskgroups can always be rebalanced to have a small
 * percent imbalance. However the failure group configuration of a normal or
 * high redundancy diskgroup may make it impossible to make the diskgroup well
 * balanced.
 */
column  "Type"  format A10 Heading "Diskgroup|Redundancy"

select g.name                                                 "Diskgroup" /* Name of the diskgroup */
     ,  100*( max((d.total_mb-d.free_mb)/d.total_mb)
             -min((d.total_mb-d.free_mb)/d.total_mb)
           ) /max((d.total_mb-d.free_mb)/d.total_mb)          "Imbalance" /* Percent diskgroup allocation is imbalanced  */
     ,  100*(max(d.total_mb)-min(d.total_mb))/max(d.total_mb) "Varience"  /* Percent difference between largest and smallest disk */
     ,  100*(min(d.free_mb/d.total_mb))                       "MinFree"   /* The disk with the least free space as a percent of total space */
     ,  count(*)                                              "DiskCnt"   /* Number of disks in the diskgroup */
     ,  g.type                                                "Type"      /* Diskgroup redundancy */
  from &asm_disk d , &asm_diskgroup g
 where d.group_number = g.group_number 
   and d.group_number <> 0 
   and d.state = 'NORMAL' 
   and d.mount_status = 'CACHED'
 group by g.name , g.type
    ;

/*
 * query to see if there are partner imbalances
 *
 * This query only returns rows for normal or high redundancy diskgroups.
 * You will not get any rows if all your diskgroups are external.
 */

/*
 * This query checks how even the partnerships are laid out for the diskgroup.
 * If the disks are different sizes or the failure groups are different sizes,
 * then the partnerships may not be balanced. Uneven numbers of disks in
 * failure groups can result with some disks having fewer partners. Uneven
 * disk sizes result in some disks having more partner space than others.
 * Primary extents are allocated to a disk based on its size. The secondary
 * extents for those primaries are allocated on its partner disks. A disk with
 * less partner space will fill up those partners more than a disk with more
 * partner space. At the beginning of a rebalance, partnerships may be
 * rearranged. The partnerships being dropped are marked as inactive. This
 * query only examines active partnerships since it is attempting to
 * evaluate problems based on the structure of the diskgroup, not the
 * transient state that may exist at the moment. At the completion of a
 * successful rebalance the inactive partnerships will be deleted.
 */

/*
 * Partner count imbalance gives the difference in the number of partners for
 * the disk with the most partners and the disk with the fewest partners. It
 * may not be possible for every disk to have the same number of partners
 * even when all the failure groups are the same size. However an imbalance
 * of more than one indicates that the failure groups are different sizes.
 * In any case it maybe impossible to get a percent imbalance of zero when
 * some disks have more partners than others.
 */
column  "PImbalance" format 99 Heading "Partner|Count|Imbalance"

/*
 * Partner space imbalance indicates if some disks have more space in their
 * partners than others. The partner space is calculated as a ratio between
 * the size of a disk and the sum of the sizes of its active partners. This
 * ratio is compared for all the disks. The difference in the highest and
 * lowest partner space is reported as a percentage. It is impossible to
 * achieve a percent imbalance of zero unless this is zero. An imbalance of
 * 10% is acceptible.
 * Inactive partners are not considered in this calculation since the
 * allocations across an inactive partnership will be relocated by rebalance.
 */
column  "SImbalance" format 99.9 Heading "Partner|Space %|Imbalance"

/*
 * Failgroup Count reports the number of failure groups. This gives a sense
 * of how widely the partners of a disk can be spread across different
 * failure groups.
 */
column  "FailGrpCnt" format 9999 Heading "Failgroup|Count"

/*
 * Inactive Partnership Count reports the number of partnerships which are
 * no longer used for allocation. A successful rebalance will eliminate these
 * partnerships. If this is not zero then a rebalance is needed or is in
 * progress.
 */
column "Inactive" format 9999 Heading "Inactive|Partnership|Count"

select g.name                                          "Diskgroup"  /* Name of the diskgroup */
     , max(p.cnt)-min(p.cnt)                           "PImbalance" /* partner imbalance */
     , 100*(max(p.pspace)-min(p.pspace))/max(p.pspace) "SImbalance" /* total partner space imbalance */
     , count(distinct p.fgrp)                          "FailGrpCnt" /* Number of failure groups in the diskgroup */
     , sum(p.inactive)/2                               "Inactive"   /* Number of inactive partnerships in the diskgroup */
  from &asm_diskgroup g 
     , ( /* One row per disk with count of partners and total space of partners
          * as a multiple of the space in this disk. It is possible that all
          * partnerships are inactive giving a pspace of 0. To avoid divide by
          * zero when this happens for all disks, we return a very small number
          * for total partner space. This happens in a diskgroup with only two
          * failure groups when one failure group fails. */
       select x.grp                                       grp
            , x.disk                                      disk
            , sum(x.active)                               cnt
            , greatest(sum(x.total_mb/d.total_mb),0.0001) pspace
            , d.failgroup                                 fgrp
            , count(*)-sum(x.active)                      inactive
         from &asm_disk d
            , ( /* One row per  partner of a disk with partner size. We return
                 * size of zero for inactive partnerships since they will
                 * be eliminated by rebalance. */
                select y.grp                          grp
                     , y.disk                         disk
                     , z.total_mb*y.active_kfdpartner total_mb
                     , y.active_kfdpartner            active
                  from x$kfdpartner y
                     , &asm_disk    z
                 where y.number_kfdpartner = z.disk_number 
                   and y.grp = z.group_number           
               ) x
        where d.group_number = x.grp 
          and d.disk_number = x.disk 
          and d.group_number <> 0 
          and d.state = 'NORMAL' 
          and d.mount_status = 'CACHED'
        group by x.grp, x.disk, d.failgroup
    ) p
where g.group_number = p.grp
group by g.name
    ;

