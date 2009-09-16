Tom,

We are not running on Solaris therefore pmap is not available. Is there any
other way, perhaps querying v$ tables to get this information (ie. PGA memory
usage per session).

Thanks & Rgds

Rukshan


Followup:

v$sesstat joined to v$statname.



Tom, is there a way to calculate the amount of memory consumed by a user
connection (Solaris)? We are looking to move from shared to a dedicated
connection and I would like to include this in my estimate.


Followup:

v$sesstat


ops$tkyte%ORA10GR2> select a.name, b.value
  2  from v$statname a, v$sesstat b
  3  where a.statistic# = b.statistic#
  4  and a.name like '%memory%';

NAME                                VALUE
------------------------------ ----------
session uga memory                 680028
session uga memory                  90852
.....