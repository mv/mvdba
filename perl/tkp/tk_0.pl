#!/usr/bin/perl
# $Id$
#
# Marcus Vinicius Ferreira      ferreira.mv[ at ]gmail.com
#
#

use strict;
use warnings;
use File::Basename;

die<<ARGV unless @ARGV;

    Usage: $0 <files>

ARGV

foreach my $file (@ARGV) {

    pfile($file);

}
print "\n";

exit 0;

sub pfile {
    my $file = shift;
    my $line;
    my %state;
    my %sum;
    my @data;

    $state{'block'} = 0;
    $state{'RECURSIVE'} = 0;
    $state{'NON-RECURSIVE'} = 0;

    %sum =  (   cpu => 0
            ,   ela => 0
            ,  Rcpu => 0
            ,  Rela => 0
            ,  Ncpu => 0
            ,  Nela => 0
            );

    print "File: $file\n";

    open my $fh , "<", "$file" or die "Cannot open file [$file]: $!";

    while( <$fh> ) {

        print "File: $file ", $. ,"\r";
        next if /^\s*$/;

        if( /^total/ ) {
            my @column = split;
            # printf "%5d %s", $., $_ ;

            if( $state{'RECURSIVE'} ) {
                $sum{'Rcpu'} = $column[2];
                $sum{'Rela'} = $column[3];
            }
            elsif( $state{'NON-RECURSIVE'} ) {
                $sum{'Ncpu'} = $column[2];
                $sum{'Nela'} = $column[3];
            }
            else {
                $sum{'cpu'} += $column[2];
                $sum{'ela'} += $column[3];
                push @data, [ $column[2], $column[3], $. ]; # cpu, ela, line_nr
            };
        }

        if( /^OVERALL TOTALS FOR ALL NON-RECURSIVE STATEMENTS/ ) {
            # block exit
            $state{'NON-RECURSIVE'} = 1;
        } elsif( /^OVERALL TOTALS FOR ALL RECURSIVE STATEMENTS/ ) {
            # block in
            $state{'RECURSIVE'} = 1;
        }
    }
    print "\n";

    close $fh  or die "Cannot close file [$file]: $!";
    show_results( \%sum, \@data );

    return;
}

sub show_results {
    my $ref_sum  = shift;
    my $ref_data = shift;
    my @x = (0,0,0,0);

    my $cpu = $ref_sum->{'Rcpu'}+$ref_sum->{'Ncpu'};
    my $ela = $ref_sum->{'Rela'}+$ref_sum->{'Nela'};

    print "   Line perc_cpu perc_ela\n";
    print "------- -------- --------\n";
    foreach my $ref_array (@$ref_data) {
        $x[0] = $ref_array->[0] / ($cpu) * 100;
        $x[1] = $ref_array->[1] / ($ela) * 100;

        $x[2] += $x[0];
        $x[3] += $x[1];
        # printf "%7d %7.2f%% %7.2f%%\n", $ref_array->[2], @x;
    }
    print "------- -------- --------\n";
    printf"  total %7.2f%% %7.2f%%\n\n", $x[2], $x[3];

    @x = (0,0,0,0);
    print "   Line perc_cpu perc_ela\n";
    print "------- -------- --------\n";
#if(0) {
    # [ line_nr, cpu, ela ]
    @x = map { [ $_->[2], $_->[0] / ($cpu) * 100, $_->[1] / ($ela) * 100 ] } @$ref_data;
    my @sort_by_cpu = sort { $b->[1] <=> $a->[1] } @x;
    foreach my $i ( 0..10) { printf "%7d %7.2f%% %7.2f%%\n", @{$sort_by_cpu[$i]} } ;
    # foreach my $ref (@sort_by_cpu) { printf "%7d %7.2f%% %7.2f%%\n", @$ref} ;

#}
    return;
}

__END__
