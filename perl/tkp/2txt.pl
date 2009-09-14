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
    my $newf = basename($file) . "---.txt-";

    print "File: $file\n";

    open my $fh , "<", "$file" or die "Cannot open file [$file]: $!";
    open my $txt, ">", "$newf" or die "Cannot open file [$newf]: $!";

    print $txt $_ while (<$fh>);

    close $fh  or die "Cannot close file [$file]: $!";
    close $txt or die "Cannot close file [$newf]: $!";
    return;
}

__END__
