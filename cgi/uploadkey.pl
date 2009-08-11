#!/usr/bin/perl -w

use strict;
use CGI;
use Fcntl qw( :DEFAULT :flock );
use File::Basename;

use constant UPLOAD_DIR     => "/abd/git/ssh";
use constant BUFFER_SIZE    => 16_384;
use constant MAX_FILE_SIZE  => 1_048_576;       # Limit each upload to 1 MB
use constant MAX_DIR_SIZE   => 100 * 1_048_576; # Limit total uploads to 100 MB
use constant MAX_OPEN_TRIES => 100;

$CGI::DISABLE_UPLOADS   = 0;
$CGI::POST_MAX          = MAX_FILE_SIZE;

my $q = new CGI;
if ( dir_size( UPLOAD_DIR ) + $ENV{CONTENT_LENGTH} > MAX_DIR_SIZE ) {
    error( $q, "Upload directory is full. MAX_DIR_SIZE = 100MB" );
}

my $file      = $q->param( "file" )     || error( $q, "No file received." );
my $buffer    = "";
my $key       = "";

my $filename = basename( $file );
my $dirname  = dirname( $file );
my $tmpname  = "/tmp/$filename";

# Write contents to output file: test pub key
open my $tmp, ">", $tmpname || error( $1, "Error creating file: [$tmpname]");
while ( read( $file, $buffer, 16_384 ) ) {
    print $tmp $buffer;
    $key .= $buffer;
}
close $tmp;

system( "ssh-keygen -l -f $tmpname >/dev/null");
if( $? !=0 ) {
    error( $q, "[$filename] is not a public key file") ;
}

# Good key: save it
chomp $key;
my ($keytype, $k, $userid) = split / /,$key;
my $keyfile = UPLOAD_DIR . lc "/${keytype}_${userid}.pub";

open my $fh, ">", "$keyfile" || error( $q, "Error saving key: [$keyfile]");
print $fh $key,"\n";
close $fh;

print $q->header( "text/html" ),
      $q->h1( "Saved" ),
      $q->p( $q->i( "New public key:") , $keyfile ),
      $q->end_html;

# All is ok: update authorized_keys
system("sudo /abd/git/bin/set-authorized-keys.sh ");

exit 0;

sub dir_size {
    my $dir = shift;
    my $dir_size = 0;

    # Loop through files and sum the sizes; doesn't descend down subdirs
    opendir DIR, $dir or die "Unable to open $dir: $!";
    while ( my $f = readdir DIR ) {
        $dir_size += -s "$dir/$f";
    }
    return $dir_size;
}


sub error {
    my( $q, $reason ) = @_;

    print $q->header( "text/html" ),
          $q->start_html( "Error" ),
          $q->h1( "Error" ),
          $q->p( "Your upload was not procesed because the following error ",
                 "occured: " ),
          $q->p( $q->i( $reason ) ),
          $q->end_html;
    exit;
}

sub show {
    my( $q, $reason ) = @_;

    print $q->header( "text/html" ),
          $q->h1( "Show" ),
          $q->p( $q->i( $reason ) ),
          $q->end_html;
}

1;


