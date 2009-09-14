#!/bin/bash
# $Id$



[ -z "$1" ] && {
    cat <<CAT

    Usage: $0 <sql script>

CAT
exit 2
}


sqlplus /nolog <<SQL

set echo on
set time on
set timing on
set feedback on

@ ${1} apps apps


SQL



