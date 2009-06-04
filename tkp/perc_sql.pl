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
    my (%state, %sum, @data, @lines);

    %state =  ( 'RECURSIVE' => 0
              , 'NON-RECURSIVE'  => 0
              );
    %sum =  (  Rcpu => 0
            ,  Rela => 0
            ,  Ncpu => 0
            ,  Nela => 0
            );

    open my $fh , "<", "$file" or die "Cannot open file [$file]: $!";
    open my $fsql,">", "${file}.sql" or die "Cannot open sql file: $!";

    print {$fsql} "File: $file\n\n";
    print "\nFile: $file \n";
    while( <$fh> ) {

        print STDERR "File: $file - ", $. ,"\r";
        push @lines, $_;

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
    print STDERR "\n";
    close $fh   or die "Cannot close file [$file]: $!";

    show_results( \%sum, \@data, \@lines, $fsql );
    close $fsql or die "Cannot close sql file: $!";

    return;
}

sub show_results {
    my $ref_sum  = shift;
    my $ref_data = shift;
    my $ref_lines = shift;
    my $sql_file  = shift;

    my $cpu = $ref_sum->{'Rcpu'}+$ref_sum->{'Ncpu'};
    my $ela = $ref_sum->{'Rela'}+$ref_sum->{'Nela'};

    #                        [ line_nr,  cpu ##############, ela ############## ]
    my @perc        = map  { [ $_->[0],  $_->[1] / $cpu*100, $_->[2] / $ela*100 ] } @$ref_data;
    my @sort_by_cpu = sort { $b->[1] <=> $a->[1] } @perc;

    print "   Line perc_cpu perc_ela\n";
    print "------- -------- --------\n";
    foreach my $i (0.. $#sort_by_cpu ) {
        printf             "%7d %7.2f%% %7.2f%%\n", @{$sort_by_cpu[$i]};
        print  {$sql_file} "   Line perc_cpu perc_ela\n";
        print  {$sql_file} "------- -------- --------\n";
        printf {$sql_file} "%7d %7.2f%% %7.2f%%\n", @{$sort_by_cpu[$i]};
        get_sql( $sort_by_cpu[$i]->[0], $ref_lines, $sql_file );
    } ;

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

sub get_sql {
    my $lnr    = shift; # line number
    my $ref_ar = shift; # array file
    my $fh     = shift;
    my @sql;

    while( $lnr ) {

        $lnr--;

=for comment
        next if $ref_ar->[ $lnr ] =~ /^\s*$/ ;
        next if $ref_ar->[ $lnr ] =~ /^call / ;
        next if $ref_ar->[ $lnr ] =~ /^Parse   / ;
        next if $ref_ar->[ $lnr ] =~ /^Execute / ;
        next if $ref_ar->[ $lnr ] =~ /^Fetch   / ;
        next if $ref_ar->[ $lnr ] =~ /^------- / ;
        next if $ref_ar->[ $lnr ] =~ /^total / ;
=cut

        last if $ref_ar->[ $lnr ] =~ /^\*{10}/ ;

        push @sql, $ref_ar->[ $lnr ];
    }

    unless( $lnr ) {
        print {$fh}  "Error: BEGIN OF FILE!!!\n";
        print STDERR "Error: BEGIN OF FILE!!!\n";
        return;
    }

    print {$fh} reverse @sql, "\n";
    print {$fh} "\n\nEND OF SQL\n";
    print {$fh} "-" x 40, "\n\n";
    return;
}

__END__
