#!/usr/bin/perl
#
# $Id: search_col.pl 6 2006-09-10 15:35:16Z marcus $
# $Revision: 1.5 $  $Author: marcus $
#
# dump_results()

#use strict;
use DBI;

usage() unless @ARGV;

# Params
my $lst =    $ARGV[0] ;
my $str =    $ARGV[1] ;
my $sid =    $ARGV[2] ;
my $usr =    $ARGV[3] || "UXML";
my $psw =    $ARGV[4] || $usr  ;

# Variables
my $tab, $col;
my $dbh;
conn_db( $usr, $psw, $sid );

# The work to be done.....
open LIST, "< $lst"
    or die "Cannot open $lst : $! \n";

while (<LIST>)
{
    ($tab, $col) = split;
    #print "-> " . " " x (31 - length($tab)) . $tab .  "." . lc($col) . "\n";

    $sql = <<"    SQL";
    /* $0 */
    SELECT ROWID, $col
      FROM $tab
     WHERE $col LIKE '\%${str}\%'
    SQL

    $sth = $dbh->prepare ($sql);
    $sth->execute;
    $header = TRUE;
    while ( ($rowid,$val) = $sth->fetchrow_array )
    {
        if ($header)
        {
            print "\n${tab}.${col}\n";
            print "-" x (length($tab) + length($col) + 1) . "\n";
        }
        print "$rowid , $val \n";
        $header = FALSE;
    }
}

# end
close LIST
    or die "Cannot close $lst : $! . ";

$dbh->disconnect;

exit 0;

sub usage()
{
    die <<"    USAGE";

    Usage: $0 <list_name> "<string>" SID user [<password>]

        list_name:  file listing table and columns to search
        "string" :  string to search for
        SID:        Database/tns_alias
        user:       username
        <password>: password

    USAGE
}

sub conn_db()
{
    print "\n\n    $usr\@$sid Connecting.... ";

    # error Checking
    my %attr = ( PrintError => 1
               , RaiseError => 1
               );
    # Connect
    $dbh = DBI->connect("dbi:Oracle:$sid","$usr"
                                         ,"$psw"
                                         , \%attr
                                        )
                or die "\nCannot connect : ", $DBI::errstr, "\n" ;

    print "ok\n\n";
}

__END__
