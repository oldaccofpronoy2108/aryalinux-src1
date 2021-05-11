#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:evolution-data-server
#REQ:gjs
#REQ:gnome-autoar
#REQ:gnome-control-center
#REQ:gtk4
#REQ:mutter
#REQ:sassc
#REQ:startup-notification
#REQ:systemd
#REQ:asciidoc
#REQ:desktop-file-utils
#REQ:gnome-bluetooth
#REQ:gst10-plugins-base
#REQ:networkmanager
#REQ:adwaita-icon-theme
#REQ:dconf
#REQ:gdm
#REQ:gnome-backgrounds
#REQ:gnome-menus
#REQ:telepathy-mission-control


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/gnome-shell/40/gnome-shell-40.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-shell/40/gnome-shell-40.0.tar.xz


NAME=gnome-shell
VERSION=40.0
URL=https://download.gnome.org/sources/gnome-shell/40/gnome-shell-40.0.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The GNOME Shell is the core user interface of the GNOME Desktop environment."

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

