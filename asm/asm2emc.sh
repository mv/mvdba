#!/bin/bash
#
#

echo
printf "%15s %15s %15s %20s\n" ASM "minor,major" device EMC
echo "--------------- --------------- --------------- --------------------"

for disk in $( /etc/init.d/oracleasm listdisks )
do

    number=$( /etc/init.d/oracleasm querydisk $disk | awk -F'device ' '{print $2}' )

    minor=$( echo $number | awk '{print substr($1, 2)}')
    major=$( echo $number | awk '{print substr($2, 1, length($2)-1) }')
     part=$( ls -l /dev | grep "$minor" | grep "$major" | awk '{print $NF}')
      dev=$( echo $part | sed -e 's/[0-9]\+//' )

    emc=$( powermt display dev=all | awk '/^Pseudo/ { split($0,a,"="); emc=a[2] } /^ / { printf "%s [ %s ]\n", emc, $3} ' | grep $dev )

    printf "%15s %15s %15s %20s\n" $disk "$number" /dev/$part "$emc"
done

echo
echo EMC devices
echo "---------------"

powermt display dev=all | awk '
/^Pseudo/ { split($0,a,"="); emc=a[2] }
/^ /      { print "    ", emc, $3 }
' | sort | while read x
do
     emc=$( echo $x | awk '{print $1}')
    size=$( fdisk -l | grep Disk | grep $emc | awk '{print $3,$4}')
    printf "%s %10s\n" "$x" "$size"
done

echo

