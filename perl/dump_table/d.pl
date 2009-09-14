#!/bin/perl
#
# $Id
# $Revision$
#
# dump_results()

use strict;
use DBI;
use Getopt::Long;

require 'lib/ora_db_util.pl';
require 'lib/ora_gen_loader.pl';
require 'lib/ora_gen_ins_sel.pl';

# usage() unless @ARGV;

# Params
    my $sid ;
    my $usr ;
    my $pwd ;

    my @table ;
    my @schema ;

    my $if_pl ;
    my $if_ctl ;
    my $if_ins ;
    my $if_ins_pl ;

my $tab;
params();

# my $sid =    $ARGV[0] ;
# my $tab = lc($ARGV[1]) ;
# my $usr =    $ARGV[2] || "UXML";
# my $psw =    $ARGV[3] || $usr  ;

# Conexao
my $dbh = conn_db( $usr, $pwd, $sid );

foreach $tab ( get_tables(@schema) )
{
    print "    Table: $tab\n";

    # The work to be done.....
    my @columns = get_columns( $usr, $tab );
    $if_pl      && make_pl  ($usr, $pwd, $sid, $tab, @columns);
    $if_ctl     && make_ctl       ($tab, @columns);
    $if_ins     && make_ins_sel   ($tab, @columns);
    $if_ins_pl  && make_ins_sel_pl($tab, @columns);
}

# end
$dbh->disconnect;
exit 0;

sub usage()
{
    die <<"USAGE";

    Usage: $0 -user <user> [-pwd <password>] -db <database>
              < -tab <table> | -schema [schema] >
              < -ctl -pl -ins -ins_pl >

        -db:        database
        -user:      username
        -pwd:       password (defaults to "user" if null)

        -tab        looks for this table only
        -schema     looks for all tables in <schema>

        -ctl:       generates SQL*Loader controlfile        (default)
        -pl:        generates Perl script to spool file     (default)
        -ins:       generates SQL script for INSERT/SELECT
        -ins_pl:    generates PL/SQL script for INSERT/SELECT

USAGE
}

sub params
{
    my $result;
    my ($sid, $usr, $pwd);
    $result=GetOptions( "sid|db|d:s"      => \$sid
                      , "user|u:s"        => \$usr
                      , "password|pwd|p:s"=> \$pwd
                      , "tab|table|t=s"   => \@table
                      , "sch|schema|s=s"  => \@schema
                      , "pl"      => \$if_pl
                      , "ctl"     => \$if_ctl
                      , "ins"     => \$if_ins
                      , "ins_pl"  => \$if_ins_pl
                      );

    print "db       $sid\n";
    print "usr      $usr\n";
    print "pwd      $pwd\n";

    print "table    @table\n";
    print "schema   @schema\n";

    print "pl       $if_pl\n";
    print "ctl      $if_ctl\n";
    print "ins      $if_ins\n";
    print "ins_pl   $if_ins_pl\n";

    exit 1;
}
__END__
