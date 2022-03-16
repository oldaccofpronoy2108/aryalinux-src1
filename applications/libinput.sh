#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libevdev
#REQ:mtdev


cd $SOURCE_DIR

NAME=libinput
VERSION=1.20.0
URL=https://gitlab.freedesktop.org/libinput/libinput/-/archive/1.20.0/libinput-1.20.0.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://gitlab.freedesktop.org/libinput/libinput/-/archive/1.20.0/libinput-1.20.0.tar.gz


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

export XORG_PREFIX="/usr"

echo $USER > /tmp/currentuser

mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX \
      --buildtype=release   \
      -Ddebug-gui=false     \
      -Dtests=false         \
      -Dlibwacom=false      \
      ..                    &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&
if [ "$XORG_PREFIX" != "/usr" ]; then
      $SUDO mv $XORG_PREFIX/lib/udev/rules.d/* /usr/lib/udev/rules.d
      $SUDO rm -rf $XORG_PREFIX/lib/udev/
fi
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd