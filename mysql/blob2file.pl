#/usr/bin/perl
#
# QBG: Dump binary files from fogbugz Attachment table
#
# Marcus Vinicius Ferreira              ferreira.mv[ at ]gmail.com
# 2009-10

use strict;
use Data::Dumper;
use DBI;

my $dbname='fogbugz1';
my $user='';
my $pass='';

my $dbh = DBI->connect("dbi:mysql:database=$dbname","$user","$pass") or die "Cannot open db $dbname: $!";

my $array_ref = $dbh->selectall_arrayref("SELECT ixAttachment, sFilename, sData FROM Attachment");
# print Dumper( \$array_ref );

foreach my $row_ref ( @{ $array_ref } ) {

    print "File: [", $row_ref->[1], "]\n";
    open my $fh, ">", $row_ref->[1] or die "Cannot create file: $!";
    print $fh $row_ref->[2];
    close $fh;

}

exit 0;

