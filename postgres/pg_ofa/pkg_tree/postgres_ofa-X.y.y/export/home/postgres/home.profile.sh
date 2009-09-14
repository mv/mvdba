# $Id: home.profile.sh 6 2006-09-10 15:35:16Z marcus $
#
# Postgres ~/.profile
#
# Created
#       Marcus Vinicius Ferreira    Out/2004

[ -e /etc/bash.bashrc ] && . /etc/bash.bashrc
[ -e ~/.bashrc  ]       && . ~/.bashrc
[ -d ~/bin ]            && export PATH=~/bin:$PATH

EDITOR=vi
PAGER=less
export EDITOR PAGER

umask 022
ulimit -c 0     # No core dumps

# Enviroment
. ~postgres/bin/pghome.sh
. ~postgres/bin/pgofa.sh
