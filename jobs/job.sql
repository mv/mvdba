begin
    dbms_job.change
       ( 62
       , what      => 'sinacor_stats;'
       , next_date => TRUNC(SYSDATE) + 1 + 1.5/24
       , interval  =>'TRUNC(SYSDATE) + 1 + 1.5/24 /* dia seguinte às 01:30AM */'
       );
    commit;
end;


declare
    jobid number;
begin
    dbms_job.submit
       ( jobid
       , what      => 'sinacor_stats;'
       , next_date => TRUNC(SYSDATE) + 1 + 1.5/24
       , interval  =>'TRUNC(SYSDATE) + 1 + 1.5/24 /* dia seguinte às 01:30AM */'
       );
    commit;
end;
