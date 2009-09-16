
[ -z "$1" ] && exit 2

    sh tr.sh

    split -l 50 alter_trg_usr.sql trg.${1}.sql.

    for f in trg.${1}.sql.*; do echo "sqlplus apps/apps @ $f " > ${f}.sh ; done
    chmod 755 *sh

    /bin/ls -1 trg.${1}.*sh > ${1}.sh
    chmod 755 ${1}.sh
    perl -pi -e 's{^}{./}; s{$}{  \&};' ${1}.sh

echo "Done..."
