#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:bluez


cd $SOURCE_DIR

wget -nc https://github.com/blueman-project/blueman/releases/download/2.1.1/blueman-2.1.1.tar.gz


NAME=blueman
VERSION=2.1.1
URL=https://github.com/blueman-project/blueman/releases/download/2.1.1/blueman-2.1.1.tar.gz
DESCRIPTION="Blueman is a GTK+ bluetooth management utility for GNOME using bluez D-Bus backend."

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

sudo pip3 install Cython

./autogen.sh --prefix=/usr --disable-runtime-deps-check &&
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

