

alter system set sga_target=4G              ; -- scope=both; 4096m
alter system set pga_aggregate_target=6G    ; -- scope=both; 6144m

create spfile from spfile;

