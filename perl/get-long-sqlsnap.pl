#!/usr/bin/perl -w
#
# $Id: get_sql_snap.pl 6 2006-09-10 15:35:16Z marcus $
#
# SQL for snapshots dumped to a file
#
#   (all_snapshots.query LONG)

use DBI;

# error Checking
my %attr =  (   PrintError => 1
            ,   RaiseError => 1
            ,   AutoCommit => 0
            );
# Connect
my $dbh = DBI->connect("dbi:Oracle:host=irulan;sid=orcl"
                      ,"scott","tiger"
                      , \%attr )
        or die "Cannot connect : $DBI::errstr \n" ;

# Buffer for LONG datatype
    $dbh->{LongReadLen} = 16384;
    $dbh->{LongTruncOk} = 1; # Error if buffer is small

# statement
my $sth = $dbh->prepare(" /* $0 */
        SELECT owner||'.'||name name
             , query
          FROM all_snapshots
      -- WHERE owner <> 'SYS'
         ORDER BY 1
        ");

# execution
$sth->execute();

# dump to file
while ( @rows = $sth->fetchrow_array ) {

    $file = lc ($rows[0]) . ".sql" ;
    $sql  =     $rows[1];

    open FILE, ">$file" or die "Cannot open $file ($!) \n";
    print "  -- Retrieving: $file \n";
    print FILE $sql, "\n" ;
    close FILE          or die "Cannot close $file: ($!) \n";
}

# end
$dbh->disconnect
    or die "Cannot disconnect ( $DBI::errstr ) \n";
