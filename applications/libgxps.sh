#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk3
#REQ:lcms2
#REQ:libarchive
#REQ:libjpeg
#REQ:libtiff
#REQ:libxslt


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/libgxps/0.3/libgxps-0.3.2.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/libgxps/0.3/libgxps-0.3.2.tar.xz


NAME=libgxps
VERSION=0.3.2
URL=https://download.gnome.org/sources/libgxps/0.3/libgxps-0.3.2.tar.xz
SECTION="Graphics and Font Libraries"
DESCRIPTION="The libgxps package provides an interface to manipulate XPS documents."

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

meson --prefix=/usr .. &&
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

