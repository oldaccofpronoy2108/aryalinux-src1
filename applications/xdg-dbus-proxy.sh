#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://github.com/flatpak/xdg-dbus-proxy/releases/download/0.1.2/xdg-dbus-proxy-0.1.2.tar.xz


NAME=xdg-dbus-proxy
VERSION=0.1.2
URL=https://github.com/flatpak/xdg-dbus-proxy/releases/download/0.1.2/xdg-dbus-proxy-0.1.2.tar.xz
SECTION="Others"
DESCRIPTION="xdg-dbus-proxy is a filtering proxy for D-Bus connections. It was originally part of the flatpak project, but it has been broken out as a standalone module to facilitate using it in other contexts."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	if [ $NAME == "firefox" ]; then set +e; fi;
	tar --no-overwrite-dir -xf $TARBALL
	set -e
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

./configure --prefix=/usr
make

sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

