#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:xorg-server

cd $SOURCE_DIR

wget -nc https://www.x.org/pub/individual/driver/xf86-input-vmmouse-13.1.0.tar.bz2

NAME=xorg vmmouse driver-13.1.0
VERSION=13.1.0
URL=https://www.x.org/pub/individual/driver/xf86-input-vmmouse-13.1.0.tar.bz2

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

./configure $XORG_CONFIG               \
            --without-hal-fdi-dir      \
            --without-hal-callouts-dir \
            --with-udev-rules-dir=/lib/udev/rules.d &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
