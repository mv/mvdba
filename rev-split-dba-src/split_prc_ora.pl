#!/usr/bin/perl -w
# $Id: split_prc_ora.pl 6 2006-09-10 15:35:16Z marcus $
#
# split_prc_ora
#
use strict;
use Getopt::Std;

my $is_hdr=1;  # is looking for header
my @hdrs;
my $hdrs;
my %src;
my ($owner, $name, $type, $line, $text, $wrap, $file);

my %ext = ( "PROCEDURE"     => 'prc',
            "TRIGGER"       => 'trg',
            "PACKAGE"       => 'pks',
            "PACKAGE BODY"  => 'pkb',
            "VIEW"          => 'vw',
           );

my %opt = ( n   => 0,
          , h   => 0);
Getopt::Std::getopts('n', \%opt);
usage() if $opt{h};
usage() unless @ARGV;

printf "    %-30s %-12s %-s\n","Name","Type","File script";
print  "    ","-" x 30," ", "-" x 12," ", "-" x 20, "\n";

while( <> ) {

    # column header is a must
    if ($is_hdr) {          # ignores until finds first '----------'
        if ( m/^-/ ) {
            $is_hdr=0;   # found
            @hdrs = map { "A" . (length($_)+1) . " " } split;
            foreach( @hdrs ) { $hdrs .= $_ };
            next;
        }
        else { next ; }
    }

    # ignores: sqlplus SET HEADING ON / SET PAGESIZE xxx
    next if /^\s*$/;
    next if /OWNER\s*NAME\s*TYPE\s*LINE/;
    next if /^----/;

    # parse line
    ($owner, $name, $type, $line, $text) = unpack $hdrs, $_ ;

    # column in wrap mode
    if( $owner eq '' && $name eq '' && $type eq '' && $line eq '' ) {
        $wrap .= $text;
        next;
    }
    else { $wrap = ''; }

    # new source/object
    if( ! exists $src{$owner}->{$name}->{$type} ) {

        $src{$owner}->{$name}->{$type} = 1;
        $file = lc($owner) . "." . lc($name) . "." . $ext{$type} . ".sql";
        open(PLSQLSRC, ">", $file) or die "    Cannot open $file: $!" if ! $opt{n};

        printf "    %-30s %-12s %-s\n",$name,$type,$file;
    }

    # save source code
    print PLSQLSRC "$text" . $wrap . "\n" if ! $opt{n};
}

# print "$hdrs \n" ;
# print $src{ $owner }->{ $name }->{ $type }->{ $line }," \n";

if ($is_hdr) { die "    No HEADER for columns found in spool."; }
else         { exit 0; }

sub usage {
    print <<EOF;

    Usage: $0 [-n] [-h] <list.txt>

        -h: This help.
        -n: DO NOT create scripts.

EOF
    exit 2;
}
