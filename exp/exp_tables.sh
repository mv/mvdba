#!/bin/bash
#
# exp_tables.sh
#       Template: exp a set of tables
#
# Marcus  Vinicius Ferreira                 ferreira.mv[ at ]gmail.com
#


[ -z "$1" ] && {

    echo
    echo "Usage: $0 <dump_file>"
    echo
    exit 1
}

[ -z "$CONN" ] && {
    echo "CONN string not defied!"
    exit 2
}

exp $CONN \
            rows=y grants=n indexes=n compress=n constraints=n statistics=none \
            direct=y buffer=10000000 RECORDLENGTH=65535 \
            file=${1}.dmp log=exp_${1}.log              \
            tables= \
\( ifd_adm.PLATAFORMA , ifd_adm.CATEGORIA , ifd_adm.CLASSIFICACAO , ifd_adm.DOWNLOAD_VERSAO , ifd_adm.DOWNLOAD \
 , ifd_adm.DOWNLOAD_DESTAQUE , ifd_adm.DOWNLOAD_ITEM_ALBUM , ifd_adm.DOWNLOAD_PATROCINADO \
 , ifd_adm.DOWNLOAD_TAG , ifd_adm.FABRICANTE , ifd_adm.TAG , ifd_adm.TAG_GRUPO \
\)

