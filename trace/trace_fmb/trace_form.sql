
-- DROP TABLE trace_form;

CREATE TABLE trace_form
( form_name     VARCHAR2(60)
, trace_enable  CHAR(1)     DEFAULT 'N'
);

ALTER TABLE trace_form
    ADD CONSTRAINT pk_trace_form PRIMARY KEY (form_name);

CREATE OR REPLACE TRIGGER tr_trace_form_biu
                   BEFORE INSERT
                       OR UPDATE
                       ON trace_form
                      FOR EACH ROW
BEGIN
    :NEW.trace_enable := UPPER(:NEW.trace_enable);
END;
/
