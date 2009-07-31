#!/bin/bash
#
# cron:
#     atualiza git clones para uso do Trac
#
# Marcus Vinicius Ferreira 			ferreira.mv[ at ]gmail.com
# 2009/Jul
#

 PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
  DIR=/data/git
  LOG=${DIR}/cron-git-pull.log
OWNER="root:apache"

[ "$1" != "-f" ] && {
    echo
    echo "Usage: $0 -f"
    echo
    echo "    atualiza git clones para o Trac e gera log: $LOG"
    echo
    exit 1
}

# Verbose-from-the-hell + redirection
exec 1>>${LOG}
exec 2>>${LOG}

echo
echo "$( date "+%Y-%m-%d_%H%M" ) - BEGIN"
cd $DIR

# Just in case.....
chown -R $OWNER .
chmod -R g+w    .

# Git pull
for proj in *
do
    [ ! -d ${DIR}/$proj ] && continue
    cd ${DIR}/$proj
    echo "$( date "+%Y-%m-%d_%H%M" ) - $proj"
    git pull
done

# Again...
chown -R $OWNER .
chmod -R g+w    .

echo "$( date "+%Y-%m-%d_%H%M" ) - END"
echo "____________________________________________________________"
echo

# Rotate if > 5Mb
size=$( /bin/ls -l $LOG | awk '{print $5}' )
[ $size -gt 5242880 ] && >$LOG

