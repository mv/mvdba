-- Create table
create table log -- AGC_ADM.LOG
( COD_LOG      NUMBER not null
, DAT_LOG      TIMESTAMP(6) not null
)
PARTITION BY LIST ( dat_log )
    ( PARTITION log_01 VALUES ( TO_TIMESTAMP( '01','MM' ) ) TABLESPACE agc_log_data_01 -- 01-12 months
    , PARTITION log_02 VALUES ( TO_TIMESTAMP( '02','MM' ) ) TABLESPACE agc_log_data_02
    , PARTITION log_03 VALUES ( TO_TIMESTAMP( '03','MM' ) ) TABLESPACE agc_log_data_03
    )
;

alter table LOG
  add constraint PK_LOG primary key (COD_LOG)
  using index tablespace AGC_INDX_01
  ;

