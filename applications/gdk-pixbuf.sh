#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2
#REQ:libjpeg
#REQ:libpng
#REQ:shared-mime-info
#REQ:libtiff


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.6.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.6.tar.xz


NAME=gdk-pixbuf
VERSION=2.42.6
URL=https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.6.tar.xz
SECTION="X Libraries"
DESCRIPTION="The Gdk Pixbuf package is a toolkit for image loading and pixel buffer manipulation. It is used by GTK+ 2 and GTK+ 3 to load and manipulate images. In the past it was distributed as part of GTK+ 2 but it was split off into a separate package in preparation for the change to GTK+ 3."

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
cd build &&

meson --prefix=/usr -Dgtk_doc=false .. &&
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

