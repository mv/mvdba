
[ -z "$1" ] && exit 2

    sh pks.sh

    split -l $2 alter_pks_usr.sql pks.${1}.sql.

    for f in pks.${1}.sql.*; do echo "sqlplus apps/apps @ $f " > ${f}.sh ; done
    chmod 755 *sh

    /bin/ls -1 pks.${1}.*sh > ${1}.sh
    chmod 755 ${1}.sh
    perl -pi -e 's{^}{./}; s{$}{  \&};' ${1}.sh

echo "Done..."
