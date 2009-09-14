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
    my (%state, %sum, @data);

    %state =  ( 'RECURSIVE' => 0
              , 'NON-RECURSIVE'  => 0
              );
    %sum =  (  Rcpu => 0
            ,  Rela => 0
            ,  Ncpu => 0
            ,  Nela => 0
            );

    open my $fh , "<", "$file" or die "Cannot open file [$file]: $!";
    print "\nFile: $file \n";
    while( <$fh> ) {

        print STDERR "File: $file - ", $. ,"\r";
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
                push @data, [ $., $column[2], $column[3] ]; # line_nr, cpu, ela
            };
        }
        elsif( /^OVERALL TOTALS FOR ALL NON-RECURSIVE STATEMENTS/ ) {
            $state{'NON-RECURSIVE'} = 1;
        }
        elsif( /^OVERALL TOTALS FOR ALL RECURSIVE STATEMENTS/ ) {
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

    my $cpu = $ref_sum->{'Rcpu'}+$ref_sum->{'Ncpu'};
    my $ela = $ref_sum->{'Rela'}+$ref_sum->{'Nela'};

    #                        [ line_nr,  cpu ##############, ela ############## ]
    my @perc        = map  { [ $_->[0],  $_->[1] / $cpu*100, $_->[2] / $ela*100 ] } @$ref_data;
    my @sort_by_cpu = sort { $b->[1] <=> $a->[1] } @perc;

    print "   Line perc_cpu perc_ela\n";
    print "------- -------- --------\n";
    foreach my $i (0..10) { printf "%7d %7.2f%% %7.2f%%\n", @{$sort_by_cpu[$i]} } ;

    #
    my @total = (0,0); #= map{ [ ] } @$ref_data;
    foreach (@perc) {
        $total[0] += $_->[1] ;
        $total[1] += $_->[2] ;
    }
    print "   ....     ....     ....\n";
    printf"  %5d sql(s)\n", $#perc + 1;
    print "------- -------- --------\n";
    printf"  total %7.2f%% %7.2f%%\n\n", @total;

    return;
}

__END__
