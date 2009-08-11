#
# Ref: http://www.orafaq.com/wiki/Scripts#AWK_Scripts
###############################################################
#   Developer : Manoj Murumkar
#        Date : 21-Apr-03
# Description : This script extracts SQL statements
#               from export dump file.
#               Set N=1 if you want the statement to be output.
#        NOTE : Use gawk(GNU version) available on GNU
#               site for best results.
###############################################################
// { N=0; }
/^CONNECT/      { N=0; }
/^CREATE SYNONYM /      { N=0; }
/^CREATE SEQUENCE /     { N=0; }
/^CREATE DATABASE LINK /        { N=0; }
/^CREATE TABLE /        { N=0; }
/^CREATE INDEX /        { N=0; }
/^ALTER /       { N=0; }
/^ANALYZE /     { N=0; }
/^GRANT /       { N=1; }
/^AUDIT /     { N=0; }

N==1 { for (i=1; i<= NF; i++) addword($i);
printline();
printf "/\n";
}

function addword(w) {
if (length(line) + length(w) > 78)
    printline()
    line = line " " w
}

function printline () {
  if (length (line) > 0) {
     print substr(line,2)  # removes leading blanks
     line = ""
  }
}

