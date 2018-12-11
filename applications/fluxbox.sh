#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:installing
#OPT:dbus
#OPT:fribidi
#OPT:imlib2

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/fluxbox/fluxbox-1.3.7.tar.xz
wget -nc ftp://ftp.jaist.ac.jp/pub//sourceforge/f/fl/fluxbox/fluxbox/1.3.7/fluxbox-1.3.7.tar.xz

NAME=fluxbox
VERSION=1.3.7
URL=https://downloads.sourceforge.net/fluxbox/fluxbox-1.3.7.tar.xz

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

./configure --prefix=/usr &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

echo startfluxbox > ~/.xinitrc

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
mkdir -pv /usr/share/xsessions &&
cat > /usr/share/xsessions/fluxbox.desktop << "EOF"
<code class="literal">[Desktop Entry] Encoding=UTF-8 Name=Fluxbox Comment=This session logs you into Fluxbox Exec=startfluxbox Type=Application</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

mkdir -v ~/.fluxbox &&
cp -v /usr/share/fluxbox/init ~/.fluxbox/init &&
cp -v /usr/share/fluxbox/keys ~/.fluxbox/keys
cd ~/.fluxbox &&
fluxbox-generate_menu <em class="replaceable"><code><user_options></code></em>
cp -v /usr/share/fluxbox/menu ~/.fluxbox/menu
cp /usr/share/fluxbox/styles/<theme> ~/.fluxbox/theme &&

sed -i 's,\(session.styleFile:\).*,\1 ~/.fluxbox/theme,' ~/.fluxbox/init &&

[ -f ~/.fluxbox/theme ] &&
echo "background.pixmap: </path/to/nice/image.ext>" >> ~/.fluxbox/theme ||
[ -d ~/.fluxbox/theme ] &&
echo "background.pixmap: </path/to/nice/image.ext>" >> ~/.fluxbox/theme/theme.cfg

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
