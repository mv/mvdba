# $Id: ora_code_util.pl 6 2006-09-10 15:35:16Z marcus $
#
# Code utilities
#

sub fmt
{
    my $code = shift;

    $code =~ s/^\s*CODE //gm;   # CODE followed by content
    $code =~ s/^\s*CODE$/\n/gm; # CODE alone in one line (i.e., empty line)
    return $code;
}

sub put_file
{
    my $ora_file = shift;
    my $script   = shift;

    system('[ -d ./tmp ] || mkdir ./tmp');

    open  FILE, ">./tmp/$ora_file"
        or die "Cannot open $ora_file : $! \n";
    print FILE fmt($script);
    close FILE or die "Cannot close $ora_file : $! \n";

    return 1;
}

return 1;
