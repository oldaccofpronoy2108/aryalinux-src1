#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:clutter
#REQ:gnome-desktop
#REQ:libwacom
#REQ:libxkbcommon
#REQ:upower
#REQ:zenity
#REC:gobject-introspection
#REC:libcanberra
#REC:startup-notification
#REC:libinput
#REC:wayland
#REC:wayland-protocols
#REC:xorg-server
#REC:gtk3

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/mutter/3.30/mutter-3.30.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/mutter/3.30/mutter-3.30.2.tar.xz

NAME=mutter
VERSION=3.30.2
URL=http://ftp.gnome.org/pub/gnome/sources/mutter/3.30/mutter-3.30.2.tar.xz

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

./configure --prefix=/usr \
--disable-static \
--enable-compile-warnings=minimum &&
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
