#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gtk2
#REC:gtk3

cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/gtk-xfce-engine/3.2/gtk-xfce-engine-3.2.0.tar.bz2

NAME=gtk-xfce-engine
VERSION=3.2.0.
URL=http://archive.xfce.org/src/xfce/gtk-xfce-engine/3.2/gtk-xfce-engine-3.2.0.tar.bz2

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

sed -i 's/\xd6/\xc3\x96/' gtk-3.0/xfce_style_types.h &&
./configure --prefix=/usr --enable-gtk3 &&
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
