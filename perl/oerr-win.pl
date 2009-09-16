<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=windows-1252"></HEAD>
<BODY onbeforeunload="" onunload=""><PRE>#! perl -w
#
#Perl script in Windows simulating the Oracle oerr utility in UNIX
#I assume you installed Perl for Windows on the same machine you installed 
#Oracle Documentation. This script is best run indirectly by oerr.bat (see 
#the URL below) instead of directly.

#This script is published as freeware at
#http://www.stormloader.com/yonghuang/freeware/Windowsoerr.html
#(C) Copyright 2000 Yong Huang (yong321@yahoo.com)

#Please modify two parameters, $dir and $colon.
#
#On your computer, open Oracle Documentation homepage with a Web browser 
#and find the error message page. E.g. for Version 8.1, it may be 
#Oracle8i Server -&gt; Oracle8i Error Messages (in section References). For 
#Version 7, it may be Oracle7 Server -&gt; Server Messages. Find the URL for 
#the message page (if it's in an HTML frame, View Frame Info in Netscape, 
#Properties in IE). Take the string before "\TOC.HTM". Follow my format 
#below. E.g., on my machine, the URL for error message Table of Contents 
#page is
#   for 8.1.5 Enterprise Ed
#	file:///D|/orant/DOC/SERVER.815/a67785/toc.htm in Netscape
#	D:\orant\DOC\SERVER.815\a67785\toc.htm in IE
#   for 8.0.5 Workgroup Ed
#	file:///D|/orant/doc/database.804/a58312/toc.htm in Netscape
#	D:\orant\doc\database.804\a58312\toc.htm in IE
#   for 7.3.4 Workgroup Ed
#	file:///D|/oracle7doc/DOC/server/doc/MSG73/toc.htm in Netscape
#	file:///D:/oracle7doc/DOC/server/doc/MSG73/toc.htm in IE
#Note: for $dir as shown below, use "/" not "\", no "/" at the end
#$dir="d:/oracle7doc/DOC/server/doc/MSG73";
#$dir="d:/orant/doc/database.804/a58312";
$dir="d:/orant/doc/server.815/a67785";
#
#$colon=":";
#Let's say you look up ORA-00600. Click on it. If you see
#	ORA-00600 internal error code...
#please comment out the line by prepending # so $colon=":" is not set
#If you see
#	ORA-00600: internal error code...
#leave it as is. If you're not sure, try both.
#
#You don't have to do anything below this line. But hacking is welcome.

if ($#ARGV!=1)
 { print "Usage: oerr facility errornumber
 where facility is case-insensitive and not limited to ORA
 Please open oerr.pl with a text editor and modify \$dir if you haven't done so
 Example: oerr ora 18\n";
   exit 1;
 }
 
#Files HREFed on all lines that contain 5 consecutive digits will be searched. 
#However, some error messages are accessed through links that don't have 5 
#consecutive digits such as PL/SQL Error Messages (with facility "PLS" instead
#of "ORA"), Video Server Messages etc. Since PL/SQL is so important but you may
#never "oerr ovs 506", I only add PL/SQL to the regexp (the "if" line).
#This kind of hacking strongly depends on Oracle version. I only tested on 
#Oracle 7.3.4 and 8.0.5 documentation.
open TOC, "$dir/toc.htm" or die "Can't open toc.htm: $!";
while (&lt;TOC&gt;)
 { if (/\d\d\d\d\d/ or /PL\/SQL/)  #Can't use /PL\/SQL Error/; there's a NL
    { #If you know the case of the "HREF" below, change it accordingly and 
      #remove the i modifier. It'll run faster.
      /HREF="(.*?\.htm)/i;
      $allfile{$1}=1 if defined $1;	#use hash to ensure uniqueness
      #Last version uses array which contains some filenames more than once
      #That's very bad when running against Ver. 7.3.4 Documentation
      #push @allfile,$1 if defined $1;
    }
 }
close TOC;

$facility=uc $ARGV[0];
$code=$facility."-".(sprintf "%05d",$ARGV[1]);	#e.g. ORA-00600, IMP-000001

#More on $colon: If the message is like "ORA-00600: int..." and you didn't set 
#$colon, suppose you look up the first message of those facilities whose title 
#contains facility name plus the error number, not just the error number, 
#you'll get this title when running my program, not the actual error 
#description. E.g. oerr imp 1, oerr nms 1... would display page title instead
#of the expected error description.

#05/21/00 note: Found another inconsistency in Oracle doc: Image Data Cartridge 
#Error Messages use "," instead of ":" after facility-errorno, e.g. "IMG-00001,"
#This is the only one I find that uses anything other than ":". If you need
#"oerr img [errono]", better comment out the line $colon=":" which may 
#introduce the problem described in last paragraph. Inconsistent documentation 
#style always pisses me off.

$code .= $colon if defined $colon;
$flag=0;

#print join("\t",keys %allfile), "\n";	#for debug

foreach $file (keys %allfile)
 { open INP, "$dir/$file" or warn "Error opening $file: $!";
   while (&lt;INP&gt;)
    { exit 0 if ($flag==1 and /$facility-/);
      if (/$code/)
       { &amp;rawprint;
         $flag=1;
	 #print "This is in file ".$file.".\n";	#for debug
       }
      elsif ($flag==1)
       { &amp;rawprint;
       }
    }
   close INP;
 }

sub rawprint { 
   s/&lt;.*?&gt;//g;	#de-HTMLize
   print unless /^\n$/;
}
</PRE></BODY></HTML>
