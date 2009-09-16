REM  Calculating used space within objects:

set serveroutput on size 1000000
spool spaced_obj.lst

DECLARE
   n_total_blocks  number;
   n_total_bytes   number;
   n_unused_blocks number;
   n_unused_bytes  number;
   n_last_used_extent_file_id  number;
   n_last_used_extent_block_id number;
   n_last_used_block           number;
   --
   -----
   --
   CURSOR c1 IS
   select segment_name
        , segment_type
        , extents
     from user_segments
    where 1=1
      and 2=2
      and extents > 0
    order by segment_type DESC
        , extents      DESC
        , segment_name ASC;

   --
   -----
   --
   FUNCTION F1 (pin_vlr IN NUMBER DEFAULT 0) RETURN VARCHAR2 IS
   BEGIN
      RETURN( TO_CHAR(pin_vlr, '99g999g999g999') );
   END F1;
   --
   -----
   --
   FUNCTION F2 (pin_vlr IN NUMBER DEFAULT 0) RETURN VARCHAR2 IS
   BEGIN
      RETURN( LPAD(TO_CHAR(pin_vlr, '999g999g999g999'),25,' ') );
   END F2;
   --
   -----
   --
   FUNCTION f_data_files (pin_file_id IN NUMBER) RETURN VARCHAR2 IS
   --
      vc_name VARCHAR2(255) := NULL;
   --
      CURSOR c1 IS
      select SUBSTR( file_name, INSTR(file_name,'/',1,4) + 1 ) data_file
        from dba_data_files
       where file_id = pin_file_id;
   BEGIN
      FOR r1 IN c1
      LOOP
         vc_name := r1.data_file;
      END LOOP;
      RETURN( LPAD(vc_name, 25, ' ') );
   END f_data_files;
   --
   -----
   --
   PROCEDURE unused_space (pivc_segment_owner IN VARCHAR2 DEFAULT USER
                          ,pivc_segment_name  IN VARCHAR2
                          ,pivc_segment_type  IN VARCHAR2 DEFAULT 'TABLE'
                          ,pin_extents        IN NUMBER
                          ) IS
   BEGIN
	dbms_space.unused_space(pivc_segment_owner
                               ,pivc_segment_name
                               ,pivc_segment_type
                               ,n_total_blocks  
                               ,n_total_bytes   
                               ,n_unused_blocks 
                               ,n_unused_bytes  
                               ,n_last_used_extent_file_id
                               ,n_last_used_extent_block_id 
                               ,n_last_used_block           
                               );
        --
        dbms_output.put_line('');
	dbms_output.put(RPAD(pivc_segment_name,15,'_'));
	dbms_output.put(F1(pin_extents     ));
	dbms_output.put(F1(n_total_blocks  ));
	dbms_output.put(F1(n_total_bytes   ));
	dbms_output.put(F1(n_unused_blocks ));
	dbms_output.put(F1(n_unused_bytes  ));
      --dbms_output.put(F_data_files(n_last_used_extent_file_id ));
        dbms_output.put(F2(n_last_used_extent_block_id));
	dbms_output.put(F1(n_last_used_block          ));
        dbms_output.put_line(' '||pivc_segment_type);
        --
   END unused_space;
   --
   -----
BEGIN
   --
   ----- Header
   --
   dbms_output.put     ('OBJECT_NAME     EXTENTS          TOTAL_BLOCKS    TOTAL_BYTES  UNUSED_BLOCKS   UNUSED_BYTES ');
 --dbms_output.put     ('              DATA_FILES');
   dbms_output.put_line('LAST_USED_EXTENT_BLCK_ID LAST_USED_BLOCK');
   --
   dbms_output.put     ('--------------- -------------- -------------- -------------- -------------- -------------- ');
 --dbms_output.put     ('------------------------ ');
   dbms_output.put_line('------------------------ ---------------');
   --   
   FOR r1 IN c1
   LOOP
      unused_space( USER
                  , r1.segment_name
                  , r1.segment_type
                  , r1.extents );
   END LOOP;
END;
/

spool off

