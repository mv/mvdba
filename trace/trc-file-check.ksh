#!/bin/ksh
#
#===============================================================================================
#
#  ORACLE Trace File Management
#
#  Checks for new Tracefiles and alerts DBA via mail 
#
#  Copyright (C) Alexander Venzke 2000
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#  
#===============================================================================================
#
#  A simple script that checks for tracefiles in udump/cdump destinations (OFA!) and
#  send DBA a mail with errocode, information or if that trace is just a SQL trace
#  renames that file
#
#  if you're using that script - please feel free to send me some feedback or just
#  what you think about that programm.
#
#  Author : Alexander Venzke (Alexander.Venzke@gmx.net / Alexander.Venzke@dab.com)
#  
#===============================================================================================
#
# Variablen
#
# your path env should include path to oraenv (/usr/local/bin or $ORACLE_HOME/bin)

dba=yourmail@mail.host

#===============================================================================================
#
# sendmail
#
#===============================================================================================

send_mail () {
	
	mailx -s "OTFCheck from host $(hostname) ad $(date)" $dba < $1
	rm -f $1
	
}

#===============================================================================================
#
# file_delete
# deletes old files (15 days)
#
#===============================================================================================

file_check () {

	cd $1
	find . -name \*.ut -mtime +15 -exec rm {} \;

}


#===============================================================================================
#
# check_trace 
# checking new tracefiles
#
#===============================================================================================

check_trace () {

	cd $1
	
	for tracefile in `ls -l *.trc 2>/dev/null | awk '{print $9}'`
	do
		datetime=` date +"%y%m%d_%H%M%S"`
		
		cat ${tracefile} | grep "PARSING IN CURSOR" > /dev/null
		
		if [ $? = 0 ] ; then
			# Usertracefile
			mv ${tracefile} usertrace_${ORACLE_SID}_${datetime}.ut
		else
			cat ${tracefile} | grep "ORA-" > /dev/null

			if [ $? = 0 ] ; then
				# ORA error
				errorcode=`cat ${tracefile} | grep "ORA-"`
				echo "Found error in tracefile ${tracefile}_processed.${datetime}.error" >/tmp/$datetime.mail
                                echo "=====================================" >>/tmp/$datetime.mail
                                echo "${errorcode}" >>/tmp/$datetime.mail
                                echo "=====================================" >>/tmp/$datetime.mail
                                mv ${tracefile} ${tracefile}_processed.${datetime}.error
			else
 				cat ${tracefile} | grep -i "deadlock" > /dev/null
				if [ $? = 0 ] ; then
				# deadlock
					echo "Found deadlock in tracefile ${tracefile}_processed.${datetime}.deadlock" >/tmp/$datetime.mail
					mv ${tracefile} ${tracefile}_processed.${datetime}.deadlock
				else
				# other error ..
					echo "Found unknown error in tracefile ${tracefile}_processed.${datetime}.unknownerror" >/tmp/$datetime.mail
					echo "Please check this file manually" >>/tmp/$datetime.mail
					mv ${tracefile} ${tracefile}_processed.${datetime}.unknownerror
				fi
			fi
		fi
		
		if [ -f /tmp/$datetime.mail ] ; then
			send_mail /tmp/$datetime.mail
		fi
	done
		
}

#===============================================================================================
#
# Main Procedure
#
#===============================================================================================

#
#	where is the oratab file 
#

if [ -r /etc/oratab ]
then
	ORATAB=/etc/oratab
else
	if [ -r /var/opt/oracle/oratab ]
	then
		ORATAB=/var/opt/oracle/oratab
	else
		echo "Can't find any oratab file"
		exit 1
	fi
fi

#
#	Process oratab file
#
cat $ORATAB | while read LINE
do
	case $LINE in
	\#*)	;;			
	'')     ;;
	*)
		ORACLE_SID=`echo $LINE | awk -F: '{print $1}' -`
		if [ "$ORACLE_SID" != '*' ]
		then
			ORAENV_ASK=NO
			. oraenv

			# deleting old files (.ut)
			file_check $ORACLE_BASE/admin/$ORACLE_SID/udump	
			
			# processing trace files
			check_trace $ORACLE_BASE/admin/$ORACLE_SID/bdump	
			check_trace $ORACLE_BASE/admin/$ORACLE_SID/udump	
		fi
	        ;;
 	esac
done	




