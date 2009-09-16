DECLARE
    --
    -- $Id: utl_file.test.sql 18665 2007-08-22 18:37:24Z marcus.ferreira $
    -- Test: utl_file_dir
    --
    fh          UTL_FILE.FILE_TYPE;
    dirname     VARCHAR2(50)    := '/usr/tmp/GOLD/outbound';
    filename    VARCHAR2(50)    := 'gold.test.txt';
    --
    PROCEDURE p (msg IN VARCHAR2) IS
    BEGIN
        UTL_FILE.PUT_LINE( fh, msg );
    END p;
    --
BEGIN
    fh := UTL_FILE.FOPEN( dirname , filename ,'A');
    --
    p('-');
    p('-  dirname = '||dirname);
    p('- filename = '||filename);
    p('-       dt = '||TO_CHAR(SYSDATE,'yyyy-mm-dd hh24:mi:ss') );
    p( RPAD('-', TO_NUMBER(TO_CHAR(SYSDATE, 'ss')+1 ) ,'-')); -- progress bar
    p( CHR(10) );
    --
    UTL_FILE.FCLOSE(fh);
    --
END;
/

