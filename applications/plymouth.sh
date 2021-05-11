#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://www.freedesktop.org/software/plymouth/releases/plymouth-0.9.4.tar.xz


NAME=plymouth
VERSION=0.9.4
URL=https://www.freedesktop.org/software/plymouth/releases/plymouth-0.9.4.tar.xz
DESCRIPTION="Plymouth provides a boot-time I/O multiplexing framework - the most obvious use for which is to provide an attractive graphical animation in place of the text messages that normally get shown during boot. (The messages are instead redirected to a logfile for later viewing.) However, in event-driven boot systems Plymouth can also usefully handle user interaction such as password prompts for encrypted file systems."

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

./configure --prefix=/usr --enable-systemd-integration --enable-static --disable-pango --disable-gtk &&
make

sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

