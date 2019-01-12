#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:fontforge
#REQ:perl-font-ttf
#REQ:perl-io-string

cd $SOURCE_DIR

wget -nc https://sourceforge.net/projects/dejavu/files/dejavu/2.37/dejavu-fonts-2.37.tar.bz2

NAME=dejavu-fonts
VERSION=2.37
URL=https://sourceforge.net/projects/dejavu/files/dejavu/2.37/dejavu-fonts-2.37.tar.bz2

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

make full-ttf
sudo mkdir -pv /usr/share/fonts/TTF/DejaVu
sudo cp -f build/*.ttf /usr/share/fonts/TTF/DejaVu

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
