#!/usr/bin/perl
#
# $Id: reversa_index.pl 6 2006-09-10 15:35:16Z marcus $
#
# dump_results()

use DBI;

die <<USAGE unless @ARGV;

    Usage: $0 SID tab_name index_name user [<password>]

        SID:        Database/tns_alias
        tab_name:   table name
        index_name:
        user:       username
        <password>: password

        Generates tab_name.snap.sql     Snapshot creation script


USAGE

# Params
my $sid = $ARGV[0] ;
my $tab = $ARGV[1] ;
my $idx = $ARGV[2] ;
my $usr = $ARGV[3] || "UXML";
my $psw = $ARGV[4] || $usr  ;

#
### Connecting
#
print <<"CONNECT";

    Connecting.... $usr\@$sid

CONNECT

# error Checking
my %attr =  (   PrintError => 1
            ,   RaiseError => 1
            );
# Connect
my $dbh = DBI->connect("dbi:Oracle:$sid","$usr"
                                        ,"$psw"
                                        , \%attr
                                        )
            or die "Cannot connect : ", $DBI::errstr, "\n" ;


# Tabelas CNS
my $sth = $dbh->prepare (" /* $0 */
                SELECT LOWER(column_name) column_name
                  FROM all_ind_columns
                 WHERE index_owner = UPPER('$usr')
                   AND index_name = UPPER('$idx')
                 ORDER BY column_position
         ");
$sth->execute; #( $usr, $tab );

while ( $colname = $sth->fetchrow_array ) {
    push @cols, $colname;
}

$list = join ( "\n         , " , @cols );
#print "( "            , $list , "\n)\n";

#### Snapshot
my $file = "${tab}_${idx}.idx.sql";
open FILE, "> $file"
    or die "Cannot open $file : $! \n";

print FILE <<INDEX ;

CREATE INDEX $idx
    ON $tab
         ( $list
         )
    TABLESPACE FED_INDX_01
    PARALLEL (DEGREE 2)
    ;

INDEX

close FILE
    or die "Cannot close $file : $! \n";


# end
$dbh->disconnect;

