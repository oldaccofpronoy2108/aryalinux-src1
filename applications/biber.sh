#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:perl-modules#perl-autovivification
#REQ:perl-modules#perl-business-isbn
#REQ:perl-modules#perl-business-ismn
#REQ:perl-modules#perl-business-issn
#REQ:perl-modules#perl-class-accessor
#REQ:perl-modules#perl-data-compare
#REQ:perl-modules#perl-data-dump
#REQ:perl-modules#perl-data-uniqid
#REQ:perl-modules#perl-datetime-calendar-julian
#REQ:perl-modules#perl-datetime-format-builder
#REQ:perl-modules#perl-encode-eucjpascii
#REQ:perl-modules#perl-encode-hanextra
#REQ:perl-modules#perl-encode-jis2k
#REQ:perl-modules#perl-file-slurper
#REQ:perl-modules#perl-perlio-utf8_strict
#REQ:perl-modules#perl-ipc-run3
#REQ:perl-modules#perl-lingua-translit
#REQ:perl-modules#perl-list-allutils
#REQ:perl-modules#perl-list-moreutils
#REQ:perl-modules#perl-log-log4perl
#REQ:perl-modules#perl-lwp-protocol-https
#REQ:perl-modules#perl-module-build
#REQ:perl-modules#perl-regexp-common
#REQ:perl-modules#perl-sort-key
#REQ:perl-modules#perl-text-bibtex
#REQ:perl-modules#perl-text-csv
#REQ:perl-modules#perl-text-roman
#REQ:perl-modules#perl-unicode-collate
#REQ:perl-modules#perl-unicode-linebreak
#REQ:perl-modules#perl-xml-libxml-simple
#REQ:perl-modules#perl-xml-libxslt
#REQ:perl-modules#perl-xml-writer
#REQ:texlive
#REQ:tl-installer
#REQ:perl-modules#perl-file-which
#REQ:perl-modules#perl-test-differences


cd $SOURCE_DIR

wget -nc https://github.com/plk/biber/archive/v2.12.tar.gz
wget -nc http://sourceforge.net/projects/biblatex/files/biblatex-3.12/biblatex-3.12.tds.tgz


NAME=biber
VERSION=2.12
URL=https://github.com/plk/biber/archive/v2.12.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi


wget -c https://github.com/plk/biber/archive/v2.12.tar.gz \
     -O biber-2.12.tar.gz
perl ./Build.PL &&
./Build
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xf ../biblatex-3.12.tds.tgz -C /opt/texlive/2019/texmf-dist &&
texhash &&
./Build install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

