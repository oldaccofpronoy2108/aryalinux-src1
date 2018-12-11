#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:extra-cmake-modules
#REQ:qtwebengine
#OPT:gnome-keyring
#OPT:krameworks5

cd $SOURCE_DIR

wget -nc https://download.kde.org/stable/falkon/3.0.1/falkon-3.0.1.tar.xz

NAME=falkon
VERSION=3.0.1
URL=https://download.kde.org/stable/falkon/3.0.1/falkon-3.0.1.tar.xz

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

rm -rf po/
sed -i 's/"5.11.", 5) == 0 ? 1 : 2/"5.10.", 5) >= 0 ? 2 : 1/' \
  autotests/webviewtest.cpp
mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DBUILD_TESTING=OFF         \
      .. &&

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
