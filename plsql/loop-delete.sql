--
-- $Id: delete_rownum.sql 6 2006-09-10 15:35:16Z marcus $
--
BEGIN
    --
    LOOP
        SET TRANSACTION USE ROLLBACK SEGMENT rbsbatchpont;
        --
        DELETE FROM ponteiro
         WHERE dttimeproc<1016593200
           AND entidade='MG001'
           AND rownum <=100000;
        --
        COMMIT;
        --
        EXIT WHEN SQL%NOTFOUND;
        --
    END LOOP;
    --
    COMMIT;
    --
END;
/
