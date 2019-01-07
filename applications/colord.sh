#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:dbus
#REQ:glib2
#REQ:lcms2
#REQ:polkit
#REQ:sqlite
#REC:gobject-introspection
#REC:libgudev
#REC:libgusb
#REC:systemd
#REC:vala
#OPT:docbook-utils
#OPT:gtk-doc
#OPT:libxslt
#OPT:sane

cd $SOURCE_DIR

wget -nc https://www.freedesktop.org/software/colord/releases/colord-1.4.3.tar.xz

NAME=colord
VERSION=1.4.3
URL=https://www.freedesktop.org/software/colord/releases/colord-1.4.3.tar.xz

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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
groupadd -g 71 colord &&
useradd -c "Color Daemon Owner" -d /var/lib/colord -u 71 \
-g colord -s /bin/false colord
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

mv po/fur.po po/ur.po &&
sed -i 's/fur/ur/' po/LINGUAS
mkdir build &&
cd build &&

meson --prefix=/usr \
--sysconfdir=/etc \
--localstatedir=/var \
-Ddaemon_user=colord \
-Dvapi=true \
-Dsystemd=true \
-Dlibcolordcompat=true \
-Dargyllcms_sensor=false \
-Dbash_completion=false \
-Ddocs=false \
-Dman=false .. &&
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
