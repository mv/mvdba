# $Id: makepkg.sh 6 2006-09-10 15:35:16Z marcus $
#
# RELEASE = postgres release
# DELIVER = SEQ + InformationSystem
#
#

RELEASE="7.4.7"
DELIVER="1ign"

PKG="postgres_ofa-${RELEASE}-noarch-${DELIVER}.tgz"

[ -f $PKG ] && /bin/rm -f $PKG

makepkg --linkadd y \
        --chown   n \
         $PKG

