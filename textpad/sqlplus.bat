@echo off

rem
rem Chamada do Textpad
rem

c:\oracle\ora81\bin\sqlplus -s %1 @c:\oracle\sqlplus.sql %2
