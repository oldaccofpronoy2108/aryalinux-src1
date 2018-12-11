#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:atk
#REQ:gdk-pixbuf
#REQ:pango
#REC:hicolor-icon-theme
#OPT:cups
#OPT:docbook-utils
#OPT:gobject-introspection
#OPT:gtk-doc

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.32.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.32.tar.xz

NAME=gtk2
VERSION=""
URL=http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.32.tar.xz

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

sed -e 's#l \(gtk-.*\).sgml#& -o \1#' \
    -i docs/{faq,tutorial}/Makefile.in      &&

./configure --prefix=/usr --sysconfdir=/etc &&

make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
gtk-query-immodules-2.0 --update-cache
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

cat > ~/.gtkrc-2.0 << "EOF"
include "/usr/share/themes/<em class="replaceable"><code>Glider</code></em>/gtk-2.0/gtkrc"
gtk-icon-theme-name = "<em class="replaceable"><code>hicolor</code></em>"
EOF

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/gtk-2.0/gtkrc << "EOF"
include "/usr/share/themes/<em class="replaceable"><code>Clearlooks</code></em>/gtk-2.0/gtkrc"
gtk-icon-theme-name = "<em class="replaceable"><code>elementary</code></em>"
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
