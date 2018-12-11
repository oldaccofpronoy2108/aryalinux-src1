#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:at-spi2-core
#REQ:atk

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.30/at-spi2-atk-2.30.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.30/at-spi2-atk-2.30.0.tar.xz

NAME=at-spi2-atk
VERSION=2.30.0
URL=http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.30/at-spi2-atk-2.30.0.tar.xz

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

mkdir build &&
cd build &&

meson --prefix=/usr .. &&
ninja

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
glib-compile-schemas /usr/share/glib-2.0/schemas
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
