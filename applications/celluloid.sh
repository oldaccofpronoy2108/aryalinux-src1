#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:mpv
#REQ:gnome-desktop-environment


cd $SOURCE_DIR

wget -nc https://github.com/celluloid-player/celluloid/releases/download/v0.21/celluloid-0.21.tar.xz


NAME=celluloid
VERSION=0.21
URL=https://github.com/celluloid-player/celluloid/releases/download/v0.21/celluloid-0.21.tar.xz
DESCRIPTION="Celluloid (formerly GNOME MPV) is a simple GTK+ frontend for mpv. It aims to be easy to use while maintaining high level of configurability."

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

./configure --prefix=/usr &&
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

