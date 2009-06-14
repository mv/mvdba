#!/bin/bash -x
#
# 

_ln_file() {

    [ -h $1/$2 ] && return  # link: ok
    
    # file: move and leave a link
    if [ -f $1/$2 ]
    then
        /bin/cp $1/$2 /u01/app/oracle/etc
        sudo rm $1/$2
        sudo ln -s /u01/app/oracle/etc/$1 $1/$2
    fi
}

_ln_file  /etc  oratab
_ln_file  /etc  oraInst.loc
_ln_file  /var/opt/oracle   oratab
_ln_file  /var/opt/oracle   oraInst.loc
    
