<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=windows-1252"></HEAD>
<BODY onbeforeunload="" onunload=""><PRE>#!/usr/local/bin/perl -w

# Description : This is the program to analyze the alert log
#               file and print out diagnostics.
# Developer   : Manoj Murumkar
# Date        : 5/29/2001

format top =
                 LOG SWITCH REPORT
                 +++++++++++++++++
 Time                                    Sequence
 __________________                      _____________
.
format STDOUT =
@&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;                      @&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;&lt;
substr("$TEST",3,13), $SEQ[$#$SEQ]
.
if ( ! $ENV{"ALERT"} ) {
  print "Set enviornment variable ALERT to Alert Log file location ! \n";
  exit(1);
}

open (FH,$ENV{"ALERT"});
while (&lt;FH&gt;) {
    if (/Mon|Tue|Wed|Thu|Fri|Sat|Sun/) {
       $TEST = $_;
       next;
    }
    # This is global variable , Global because we use it in format statement
    # Convert Input line into array and print last element which is sequence number
    # $var[$#$var] is like $NF in awk
    @SEQ = split / /;
    write if /Thread.*advanced/;
}
close(FH);
</PRE></BODY></HTML>
