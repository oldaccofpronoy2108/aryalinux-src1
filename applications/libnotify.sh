#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk3


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/libnotify/0.7/libnotify-0.7.9.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/libnotify/0.7/libnotify-0.7.9.tar.xz


NAME=libnotify
VERSION=0.7.9
URL=https://download.gnome.org/sources/libnotify/0.7/libnotify-0.7.9.tar.xz
SECTION="X Libraries"
DESCRIPTION="The libnotify library is used to send desktop notifications to a notification daemon, as defined in the Desktop Notifications spec. These notifications can be used to inform the user about an event or display some form of information without getting in the user's way."

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

echo $USER > /tmp/currentuser


mkdir build &&
cd    build &&

meson --prefix=/usr -Dgtk_doc=false -Dman=false .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

