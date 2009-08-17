15:56:05 - MVDBA@ABDDP > /

'ALTERUSER'||RPAD(USERNAME,31,'')||'GRANTCONNECTTHROUGHMVDBA;'
-----------------------------------------------------------------------
alter user AAPG_ADM                        grant connect through MVDBA;
alter user AAPG_USER                       grant connect through MVDBA;
alter user AGC_ADM                         grant connect through MVDBA;
alter user AGC_USER                        grant connect through MVDBA;
alter user AUDITCORE_ADM                   grant connect through MVDBA;
alter user AUDITCORE_USER                  grant connect through MVDBA;
alter user DBA_ABD                         grant connect through MVDBA;
alter user DIP                             grant connect through MVDBA;
alter user EST_ADM                         grant connect through MVDBA;
alter user EST_USER                        grant connect through MVDBA;
alter user EUI_ADM                         grant connect through MVDBA;
alter user EUI_USER                        grant connect through MVDBA;
alter user GSO_ADM                         grant connect through MVDBA;
alter user GSO_USER                        grant connect through MVDBA;
alter user MDDATA                          grant connect through MVDBA;
alter user MGMT_VIEW                       grant connect through MVDBA;
alter user ORACLE_OCM                      grant connect through MVDBA;
alter user ORDPLUGINS                      grant connect through MVDBA;
alter user OUTLN                           grant connect through MVDBA;
alter user PWA_ADM                         grant connect through MVDBA;
alter user PWA_DBL                         grant connect through MVDBA;
alter user PWA_USER                        grant connect through MVDBA;
alter user SCOTT                           grant connect through MVDBA;
alter user SI_INFORMTN_SCHEMA              grant connect through MVDBA;
alter user VEJ_ADM                         grant connect through MVDBA;
alter user VEJ_USER                        grant connect through MVDBA;
alter user VGNPROD                         grant connect through MVDBA;
alter user VGN_GCA_USER                    grant connect through MVDBA;
alter user VGN_USER                        grant connect through MVDBA;

29 rows selected.

15:56:05 - MVDBA@ABDDP > spool off
