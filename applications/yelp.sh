#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gsettings-desktop-schemas
#REQ:webkitgtk
#REQ:yelp-xsl
#REQ:desktop-file-utils


cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/yelp/3.36/yelp-3.36.0.tar.xz
wget -nc http://ftp.acc.umu.se/pub/gnome/sources/yelp/3.36/yelp-3.36.0.tar.xz


NAME=yelp
VERSION=3.36.0
URL=http://ftp.acc.umu.se/pub/gnome/sources/yelp/3.36/yelp-3.36.0.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The Yelp package contains a help browser used for viewing help files."

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

echo $USER > /tmp/currentuser


./configure --prefix=/usr --disable-static &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
update-desktop-database
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

