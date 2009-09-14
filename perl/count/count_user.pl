#!/usr/bin/perl -w
#
# $Id: count_user.pl 6 2006-09-10 15:35:16Z marcus $
#
# Contagem das tabelas CNS
#
# Marcus Vinicius Ferreira  Julho/2003
#

#use strict;
use DBI;
use POSIX qw(strftime);

die <<USAGE unless @ARGV;

    Usage: $0 SID <user> <password>

        <user>:     username
        <password>: password - if null assumes <username>
        SID:        Database/tns_alias

USAGE
#   foreach my $val (@ARGV) {
#       print $val, "\n";
#   }
#   die;

my $sid=$ARGV[0];
my $usr=$ARGV[1] || "UXML"   ;
my $psw=$ARGV[2] || $usr     ;
my $file = $usr . "@" .$sid . (strftime "_%Y-%m-%d", localtime) . ".txt" ;

#
### Connecting
#
print <<"CONNECT";

    Connecting.... $usr\@$sid

CONNECT

my (@tables, @rows);
my ($tabname, $tab, $result);

$tab = 0;

# error Checking
my %attr =  (   PrintError => 1
            ,   RaiseError => 0
            );

# Session Handle
my $dbh = DBI->connect ("dbi:Oracle:$sid"
                       ,"$usr","$psw"
                       ,\%attr
                       )
        or die "Cannot connect : ", $DBI::errstr, "\n" ;

# Tabelas do schema: guarda em @tables
my $sth = $dbh->prepare (" /* $0 */
        SELECT USER||'.'||table_name
          FROM user_tables
         ORDER BY 1
         ");
$sth->execute;

while ( $tabname = $sth->fetchrow_array ) {
    $tab++;
    push @tables, $tabname;
}

print "    Tables at $sid : $tab \n\n";

open FILE, ">$file"
    or die "Cannot open $file : $! \n";

# Counting @tables
foreach my $tabname ( @tables ) {

    print " " x 8, $tabname ;

    $sth = $dbh->prepare (" /* $0 : $tabname */
        SELECT TO_CHAR(COUNT(1),'999g999g999g990') qte
          FROM $tabname
         ");
    $sth->execute;
    $tab = $sth->fetchrow_array;

    $result = ' ' x (46 - length($tabname)) . " $tab \n";
    print $result ;
    print FILE $tabname . $result ;
}
$sth->finish();

# Final
$dbh->disconnect;
