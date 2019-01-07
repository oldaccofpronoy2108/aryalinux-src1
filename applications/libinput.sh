#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:mtdev
#OPT:valgrind
#OPT:gtk3
#OPT:libwacom

cd $SOURCE_DIR

wget -nc https://www.freedesktop.org/software/libinput/libinput-1.12.4.tar.xz

NAME=libinput-1.12.4
VERSION=1.12.4
URL=https://www.freedesktop.org/software/libinput/libinput-1.12.4.tar.xz

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

meson --prefix=$XORG_PREFIX \
-Dudev-dir=/lib/udev \
-Ddebug-gui=false \
-Dtests=false \
-Ddocumentation=false \
-Dlibwacom=false \
.. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/libinput-1.12.4/{html,api} &&
cp -rv Documentation/* /usr/share/doc/libinput-1.12.4/html &&
cp -rv api/* /usr/share/doc/libinput-1.12.4/api
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
