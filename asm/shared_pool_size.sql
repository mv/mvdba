DOC 
DOC Ref:
DOC     metalink 437924.1
DOC     https://metalink2.oracle.com/metalink/plsql/f?p=130:3:8227951168393627762::::p3_database_id,p3_docid,p3_black_frame,P3_SHOW_HEADER,p3_show_help:NOT,437924.1,0,0,0    
DOC 
DOC 
DOC Platform    Min    Recommended
DOC ----------- ------ -----------
DOC     32 bits  32 Mb      128 Mb
DOC     64 bit   88 Mb      150 Mb
DOC 
DOC 
DOC More datafiles a database has, more memory ASM needs:
DOC 
DOC Redundancy  ExtraOnce  ExtraEach
DOC ----------  ---------  ---------
DOC high             6 MB  1 MB every  33GB
DOC normal           3 MB  1 MB every  50GB
DOC external         2 MB  1 MB every 100GB
DOC 

SELECT SUM(bytes)/(1024*1024*1024) ddf_giga FROM V$DATAFILE;
SELECT SUM(bytes)/(1024*1024*1024) log_giga FROM V$LOGFILE a, V$LOG b WHERE a.group#=b.group#;
SELECT SUM(bytes)/(1024*1024*1024) tmp_giga FROM V$TEMPFILE           WHERE status='ONLINE'; 
 
