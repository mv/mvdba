rem
rem Migracao Sinacor
rem Jan/2008    Marcus Vinicius Ferreira        ferreira.mv[ at ]gmail.com
rem


SET NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1

sqlplus monitor/monitor@orains02_old @rev_table.sql ARISADMIN
sqlplus monitor/monitor@orains02_old @rev_table.sql ARISADMINPA
sqlplus monitor/monitor@orains02_old @rev_table.sql ARISCAT
sqlplus monitor/monitor@orains02_old @rev_table.sql A61_12913
sqlplus monitor/monitor@orains02_old @rev_table.sql A61_13383
sqlplus monitor/monitor@orains02_old @rev_table.sql A61_13405
sqlplus monitor/monitor@orains02_old @rev_table.sql A61_13447
sqlplus monitor/monitor@orains02_old @rev_table.sql A61_13462
sqlplus monitor/monitor@orains02_old @rev_table.sql A61_13502
sqlplus monitor/monitor@orains02_old @rev_table.sql A61_13522
sqlplus monitor/monitor@orains02_old @rev_table.sql A61_13542
sqlplus monitor/monitor@orains02_old @rev_table.sql A61_13562
sqlplus monitor/monitor@orains02_old @rev_table.sql A61_13602
sqlplus monitor/monitor@orains02_old @rev_table.sql A61_13622
sqlplus monitor/monitor@orains02_old @rev_table.sql A61_13682
sqlplus monitor/monitor@orains02_old @rev_table.sql A61_13702
sqlplus monitor/monitor@orains02_old @rev_table.sql A61_21
sqlplus monitor/monitor@orains02_old @rev_table.sql USUMSAF


sqlplus monitor/monitor@orains02_old @rev_index.sql ARISADMIN
sqlplus monitor/monitor@orains02_old @rev_index.sql ARISADMINPA
sqlplus monitor/monitor@orains02_old @rev_index.sql ARISCAT
sqlplus monitor/monitor@orains02_old @rev_index.sql A61_12913
sqlplus monitor/monitor@orains02_old @rev_index.sql A61_13383
sqlplus monitor/monitor@orains02_old @rev_index.sql A61_13405
sqlplus monitor/monitor@orains02_old @rev_index.sql A61_13447
sqlplus monitor/monitor@orains02_old @rev_index.sql A61_13462
sqlplus monitor/monitor@orains02_old @rev_index.sql A61_13502
sqlplus monitor/monitor@orains02_old @rev_index.sql A61_13522
sqlplus monitor/monitor@orains02_old @rev_index.sql A61_13542
sqlplus monitor/monitor@orains02_old @rev_index.sql A61_13562
sqlplus monitor/monitor@orains02_old @rev_index.sql A61_13602
sqlplus monitor/monitor@orains02_old @rev_index.sql A61_13622
sqlplus monitor/monitor@orains02_old @rev_index.sql A61_13682
sqlplus monitor/monitor@orains02_old @rev_index.sql A61_13702
sqlplus monitor/monitor@orains02_old @rev_index.sql A61_21
sqlplus monitor/monitor@orains02_old @rev_index.sql USUMSAF

