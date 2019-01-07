#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libxml2
#OPT:doxygen
#OPT:graphviz
#OPT:xmlto
#OPT:docbook
#OPT:docbook-xsl

cd $SOURCE_DIR

wget -nc https://wayland.freedesktop.org/releases/wayland-1.16.0.tar.xz

NAME=wayland
VERSION=1.16.0
URL=https://wayland.freedesktop.org/releases/wayland-1.16.0.tar.xz

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

./configure --prefix=/usr \
--disable-static \
--disable-documentation &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
