#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:glib2
#REQ:gnutls
#REQ:gsettings-desktop-schemas
#REC:make-ca

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.60/glib-networking-2.60.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib-networking/2.60/glib-networking-2.60.1.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/glib-networking-2.60.1-upstream_fixes-1.patch

NAME=glib-networking
VERSION=2.60.1
URL=http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.60/glib-networking-2.60.1.tar.xz

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

patch -Np1 -i ../glib-networking-2.60.1-upstream_fixes-1.patch
mkdir build &&
cd build &&

meson --prefix=/usr \
-Dlibproxy=disabled .. &&
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
