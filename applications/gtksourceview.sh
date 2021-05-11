#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk3
#REQ:gobject-introspection


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/gtksourceview/3.24/gtksourceview-3.24.11.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gtksourceview/3.24/gtksourceview-3.24.11.tar.xz


NAME=gtksourceview
VERSION=3.24.11
URL=https://download.gnome.org/sources/gtksourceview/3.24/gtksourceview-3.24.11.tar.xz
SECTION="X Libraries"
DESCRIPTION="The GtkSourceView package contains libraries used for extending the GTK+ text functions to include syntax highlighting."

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


./configure --prefix=/usr &&
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

