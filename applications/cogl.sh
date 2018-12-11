#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:cairo
#REQ:gdk-pixbuf
#REQ:glu
#REQ:mesa
#REQ:pango
#REQ:wayland
#REC:gobject-introspection
#OPT:gst10-plugins-base
#OPT:gtk-doc
#OPT:sdl
#OPT:sdl2

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.2.tar.xz

NAME=cogl
VERSION=1.22.2
URL=http://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.2.tar.xz

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

sed -i 's/^#if COGL/#ifdef COGL/' cogl/winsys/cogl-winsys-egl.c &&

./configure --prefix=/usr --enable-gles1 --enable-gles2         \
    --enable-{kms,wayland,xlib}-egl-platform                    \
    --enable-wayland-egl-server                                 &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
