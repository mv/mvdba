#!/bin/ksh
# -----------------------------------------------------------------------
# Filename:   cktnsnms.ksh
# Purpose:    Check if all entries in the TNSNAMES.ORA file is valid.
# Author:     Frank Naude, Oracle FAQ
# -----------------------------------------------------------------------
# Modified by: Dave Venus (dvenus@aholdusa.com) on 17-MAR-2000.
# -----------------------------------------------------------------------

# Find correct TNSNAMES.ORA location
if [ -f $ORACLE_HOME/network/admin/tnsnames.ora ];
   then  NETPATH=$ORACLE_HOME/network/admin
fi

if [ -f /var/opt/oracle/tnsnames.ora ];
   then  NETPATH=/var/opt/oracle
fi

if [ -f /etc/tnsnames.ora ];
   then  NETPATH=/etc
fi

if [ ${TNS_ADMIN} ];
   then  NETPATH=${TNS_ADMIN}
fi

if [ ! ${NETPATH} ];
   then  echo "ERROR: Unable to locate TNSNAMES.ORA file."
         exit 8
   else  echo "# Use TNSNAMES.ORA in ${NETPATH}"
fi

# Read file and test all entries...
grep -v -e '^ ' -e'^\t' -e'^$' -e '^#' -e'^)' ${NETPATH}/tnsnames.ora |
awk '{sub("=", "", $1); print $1}' |
while read NAME
do 
   OUT=`${ORACLE_HOME}/bin/tnsping $NAME | grep ADDRESS`
   if [ "${?}" = "1" ]; then 
      echo "${NAME}: Unable to ping"
   else 
      # OUT=${OUT##*PORT=}
      # Strip off the port number
      # OUT=${OUT##*Port=}
      # OUT=${OUT##*port=}
      # PORT=${OUT%%\)*}
      # echo ${NAME} is alive on port ${PORT}
      echo "${NAME} is alive"
   fi
done

######### Last Statement of: cktns.ksh #########


