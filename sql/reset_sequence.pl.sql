
CREATE OR REPLACE PROCEDURE reset_sequence (seq_name IN VARCHAR2, startvalue IN PLS_INTEGER) AS
    cval   INTEGER;
    inc_by VARCHAR2(25);
BEGIN
    EXECUTE IMMEDIATE 'ALTER SEQUENCE ' ||seq_name||' MINVALUE 0';
    EXECUTE IMMEDIATE 'SELECT ' ||seq_name ||'.NEXTVAL FROM DUAL' INTO cval;
    --
    cval := cval - startvalue + 1;
    IF cval < 0
    THEN
        inc_by := ' INCREMENT BY ';
        cval:= ABS(cval);
    ELSE
        inc_by := ' INCREMENT BY -';
    END IF;
    --
    EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || seq_name || inc_by || cval;
    EXECUTE IMMEDIATE 'SELECT ' ||seq_name ||'.NEXTVAL FROM DUAL' INTO cval;
    EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || seq_name || ' INCREMENT BY 1';
END reset_sequence;
/



