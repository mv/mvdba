<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=windows-1252"></HEAD>
<BODY onbeforeunload="" onunload=""><PRE>#!/usr/bin/perl -w

##########################################################################
# lsa - Oracle Log Switch Analyzer
# Jared Still
# jkstill@teleport.com
# jkstill@bcbso.com
##########################################################################P
#
# Here's a little tool I put together to give you an idea of how often
# log switches are occurring on a database.
#
# It does this by reading the alert log and calculating the time between
# log switches.
#
# There is a command line option ( -ignore NNN ) that will allow you to
# specify in seconds the maximum amount of time between log switches
# that you wish to see.
#
# This helps to pinpoint times of high activity.
#
# e.g.
#
#   lsa -filename alert_mydb.log -ignore 3600
#
#   lsa -instance mydb -ignore 1800
#
#   lsa -help
#
# Enjoy.
#
##########################################################################

use strict;
use Getopt::Long;
use Date::Manip;

my($result) = Getopt::Long::GetOptions(
        "instance:s",
        "lines-per-page:i" ,
        "filename:s",
        "ignore:i",
        "help",
        "debug!"
);


$main::opt_help = $main::opt_help;
if (
        ( ! $main::opt_instance &amp;&amp; ! $main::opt_filename ) ||
        ( $main::opt_instance &amp;&amp; $main::opt_filename ) ||
        $main::opt_help  )
{
        &amp;usage;
        exit 1;
}

my $logFile;
if ( $main::opt_filename ) { $logFile = $main::opt_filename }
else {

        if ( ! defined $ENV{ORACLE_HOME} ) { die "Please set ORACLE_HOME\n" }
        my @o = split(/\//, $ENV{ORACLE_HOME});
        my $oracleBase = $o[1];
        $logFile = "/${oracleBase}/admin/${main::opt_instance}/bdump/alert_${main::opt_instance}.log" ;
}

open( LOG,$logFile ) || die " unable to open logfile $logFile - $!\n";

# set lines per page if sent
$= = $main::opt_lines_per_page if defined( $main::opt_lines_per_page );

# flush output
$| = 1;

my $lookForDate=0;
my ($newDate, $oldDate);
my ($newDateStr, $oldDateStr);
my $deltaStr = undef;
my $printDate = undef;

my $totalLogSwitchTime = undef;
my $totalLogSwitches = undef;
my $dateDelta = undef;

my $debug = undef;

$main::opt_debug = $main::opt_debug;
if ( $main::opt_debug ) { $debug = 1 }
else { $debug = 0}

my $ignoreTime = undef;
$ignoreTime = $main::opt_ignore if defined( $main::opt_ignore );

my @logSwitches ;

my $optionStr=' ';

$optionStr = "Instance=" . $main::opt_instance if $main::opt_instance;
$optionStr = "File=" . $main::opt_filename if $main::opt_filename;
$optionStr .= "  Ignore=$main::opt_ignore" if $main::opt_ignore;

$optionStr = 'Options: ' . $optionStr if $optionStr;

print STDERR "Working...";

while(&lt;LOG&gt;) {

        chomp;

        /Thread.*advanced/ &amp;&amp;do { $lookForDate = 1 };

        if ( $lookForDate ) {

                my $date = Date::Manip::ParseDate($_);
                $printDate = $_;

                if ( $date ) {

                        if ( defined( $newDate )) { $oldDate = $newDate; $oldDateStr = $newDateStr };
                        $newDate = $date;
                        $newDateStr = $_;

                        if ( defined( $newDate ) &amp;&amp; defined( $oldDate ) ) {

                                my $err;
                                $dateDelta = Date::Manip::DateCalc($oldDate,$newDate,\$err,1);
                                my $weekDeltaStr = Date::Manip::Delta_Format($dateDelta,0,"%wv");
                                my $dayDeltaStr = Date::Manip::Delta_Format($dateDelta,0,"%dv");
                                my $hourDeltaStr = Date::Manip::Delta_Format($dateDelta,0,"%hv");
                                my $minuteDeltaStr = Date::Manip::Delta_Format($dateDelta,0,"%mv");
                                my $secondDeltaStr = Date::Manip::Delta_Format($dateDelta,0,"%sv");
                                $deltaStr =
                                        substr('00' . $weekDeltaStr,-2,2) . ':' .
                                        substr('00' . $dayDeltaStr,-2,2) . ':' .
                                        substr('00' . $hourDeltaStr,-2,2) . ':' .
                                        substr('00' . $minuteDeltaStr,-2,2) . ':' .
                                        substr('00' . $secondDeltaStr,-2,2) ;

                                #write;

                                print STDERR '.' if ! $debug;

                                my $currentLogSwitchTime =
                                        ($weekDeltaStr * 7 * 24 * 3600 ) +
                                        ($dayDeltaStr * 24 * 3600 ) +
                                        ($hourDeltaStr * 3600 ) +
                                        ($minuteDeltaStr * 60 ) +
                                        $secondDeltaStr;


                                $totalLogSwitchTime += $currentLogSwitchTime;
                                $totalLogSwitches++;
                                push(@logSwitches,[$printDate,$deltaStr]);

                                if ( $ignoreTime &amp;&amp; ( $currentLogSwitchTime &gt;= $ignoreTime ) ) {
                                        $totalLogSwitchTime -= $currentLogSwitchTime;
                                        $totalLogSwitches--;
                                        pop(@logSwitches);
                                }

                                $lookForDate = 0;

                        }

                        if ( $debug ) {
                                print STDERR "\tOLD DATE:  $oldDateStr\n";
                                print STDERR "\tNEW DATE:  $newDateStr\n";
                                print STDERR "\tDELTA:     $dateDelta\n";
                                print STDERR "\tDELTA STR: $deltaStr\n";
                                print STDERR "\t------------------\n";
                        }

                }
        }

}

print STDERR "\n\n";

my $el;
for $el ( 0 .. $#logSwitches ) {
        #print "EL: $el\n";
        #print "Date : $logSwitches[$el]-&gt;[0]\n";
        #print "Delta: $logSwitches[$el]-&gt;[1]\n";
        #print "----------------\n";
        write;
}

print "\n\n";


my $avgLogSwitchSeconds = int($totalLogSwitchTime / $totalLogSwitches);
my $avgLogSwitchMinutes = int( ($totalLogSwitchTime / $totalLogSwitches) / 60 );

print "Total Logswitches:         $totalLogSwitches\n";
print "Avg Log Switch Frequency:  $avgLogSwitchMinutes Minutes and ",  $avgLogSwitchSeconds%60, " Seconds\n\n";


format top =

     Log Switch Frequency

@&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;
$optionStr

                          Elapsed Time
Logswitch                 WW:DD:HH:MM:SS
------------------------  --------------
.

format STDOUT =
@&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;  @&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;
$logSwitches[$el]-&gt;[0], $logSwitches[$el]-&gt;[1]
.

sub usage {
        print &lt;&lt;EOF

lsa - Log Switch Analyzer
   lsa will read your alert.log file, or a specified file.
   either the -filename or -instance option must be specified.
   options are:

        instance       - which Oracle instance
        filename       - filename to read log switch info
        lines-per-page - how many lines per page to print
                    default is 60
        ignore         - ignore log switches where elapsed
                    time is N seconds.  Useful to target
                    only peak periods of activity in
                    the alert log.


EOF
}
</PRE></BODY></HTML>
