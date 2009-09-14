# $Id: postgres.sh 6 2006-09-10 15:35:16Z marcus $
#
# PostgresSQL
#
# Marcus Vinicius Ferreira   Out/2004
#

DIR=/u01/app/postgres/product/7.4.7

if [ -d $DIR ]
then

    [ `echo $PATH | /bin/egrep "(^|:)${DIR}/bin($|:)"` ]            || \
             PATH=${DIR}/bin:${PATH}

    [ `echo $MANPATH | /bin/egrep "(^|:)${DIR}/man($|:)"` ]         || \
             MANPATH=${DIR}/man:${MANPATH}

    [ `echo $LD_LIBRARY_PATH | /bin/egrep "(^|:)${DIR}/lib($|:)"` ] || \
             LD_LIBRARY_PATH=${DIR}/lib:${LD_LIBRARY_PATH}

    export PATH MANPATH LD_LIBRARY_PATH

fi

unset DIR

