
-- alter  sequence  sq_pessoa_01  maxvalue  9141745+1  ;
-- alter  sequence  sq_perfi_01   maxvalue  639054+1   ;

DECLARE
    procedure seq_reset( p_seq_name in varchar2 )
    is
        -- Ref: http://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:951269671592
        l_val number;
    begin
        -- current value
        execute immediate 'select '         || p_seq_name || '.nextval from dual' INTO l_val;

        -- increment = negative current value
        execute immediate 'alter sequence ' || p_seq_name || ' increment by -' || l_val || ' minvalue 0';

        -- set new value
        execute immediate 'select '         || p_seq_name || '.nextval from dual' INTO l_val;

        -- back to normal
        execute immediate 'alter sequence ' || p_seq_name || ' increment by 1 minvalue 0';
    end;
    --
    procedure seq_set_to( p_seq_name in varchar2 , p_new_value in number )
    is
        l_val number;
    begin
        -- current value
        execute immediate 'select '         || p_seq_name || '.nextval from dual' INTO l_val;

        -- new value
        l_val := p_new_value - l_val;

        -- new increment to make a reset
        execute immediate 'alter sequence ' || p_seq_name || ' increment by ' || l_val || ' minvalue 0';

        -- set new value
        execute immediate 'select '         || p_seq_name || '.nextval from dual' INTO l_val;

        -- back to normal
        execute immediate 'alter sequence ' || p_seq_name || ' increment by 1 minvalue 0';
    end;
    --
BEGIN
    seq_set_to( 'sq_pessoa_01', 9141745 + 1);
    seq_set_to( 'sq_perfi_01' ,  639054 + 1);
END;
/

