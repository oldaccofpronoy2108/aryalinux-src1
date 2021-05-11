#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://github.com/jackaudio/jack2/archive/v1.9.18/jack2-v1.9.18.tar.gz


NAME=jack2
VERSION=1.9.18
URL=https://github.com/jackaudio/jack2/archive/v1.9.18/jack2-v1.9.18.tar.gz
DESCRIPTION="JACK2 aka jackdmp is a C++ version of the JACK low-latency audio server for multi-processor machines. It is a new implementation of the JACK server core features that aims at removing some limitations of the JACK1 design."

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

./waf configure --prefix=/usr &&
./waf build
sudo ./waf install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

