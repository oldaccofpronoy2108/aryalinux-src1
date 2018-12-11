#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:adwaita-icon-theme
#REQ:gtk3
#REQ:itstool
#REQ:vala

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/baobab/3.28/baobab-3.28.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/baobab/3.28/baobab-3.28.0.tar.xz

NAME=baobab
VERSION=3.28.0
URL=http://ftp.gnome.org/pub/gnome/sources/baobab/3.28/baobab-3.28.0.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

mkdir build &&
cd    build &&

meson --prefix=/usr .. &&
ninja

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
