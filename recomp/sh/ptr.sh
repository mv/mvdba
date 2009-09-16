
[ -z "$1" ] && exit 2

    sh pkb.sh

    split -l 50 alter_pkb_usr.sql pkb.${1}.sql.

    for f in pkb.${1}.sql.*; do echo "sqlplus apps/apps @ $f " > ${f}.sh ; done
    chmod 755 *sh

    /bin/ls -1 pkb.${1}.*sh > ${1}.sh
    chmod 755 ${1}.sh
    perl -pi -e 's{^}{./}; s{$}{  \&};' ${1}.sh

echo "Done..."
