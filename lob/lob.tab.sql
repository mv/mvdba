
CREATE TABLE test_lobtable
( id  NUMBER
, xml_file CLOB
, image    BLOB
, log_file BFILE
) TABLESPACE tst_data_01
LOB (xml_file)
    STORE AS xml_file_lob_seg (
        TABLESPACE lob_data
        CHUNK 4096
        CACHE
        STORAGE (MINEXTENTS 2)
        INDEX xml_file_lob_idx (
            TABLESPACE lob_index
            STORAGE (MAXEXTENTS UNLIMITED)
        )
    )
LOB (image)
    STORE AS image_lob_seg (
        TABLESPACE lob_data
        ENABLE STORAGE IN ROW
        CHUNK 4096
        CACHE
        STORAGE (MINEXTENTS 2)
        INDEX image_lob_idx (
            TABLESPACE lob_index
        )
    )
/

-- alter table t move lob(y) store as ( tablespace users )

