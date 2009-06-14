#!/bin/bash -x
#
# 

_mk_oinstall() {
    mkdir -p $1 && chown oracle:oinstall $1 && chmod 775 $1
}

_mk_dba() {
    mkdir -p $1 && chown oracle:dba $1 && chmod 775 $1
}

_setup() {

    _mk_oinstall /u01/app/oracle/oraInventory
    _mk_dba      /u01/app/oracle/admin
    _mk_dba      /u01/app/oracle/etc
    
}

_product() {
    _mk_dba      /u01/app/oracle/product/$1
}

_oradata() {
    _mk_dba  /$1/oradata/$2
    _mk_dba  /$1/flash/$2
    _mk_dba  /$1/arch/$2
    _mk_dba  /$1/bkp/$2
}

_admin() {
    cd /u01/app/oracle/admin
    
    [ ! -d "$1" ] && _mk_dba $1
    for d in adump bdump cdump udump create pfile transport exp
    do
        [ ! -d $1/$d ] && _mk_dba $1/$d
    done
}

  _setup
  _product  10.2.0.1/db_1
  _product  10.2.0.4/db_1
  _admin    orcl
  _oradata  u01 orcl
  _oradata  u02 orcl

