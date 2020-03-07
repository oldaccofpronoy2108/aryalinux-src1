#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:krameworks5
#REQ:mlt
#REQ:v4l-utils
#REQ:breeze-icons


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/release-service/19.12.2/src/kdenlive-19.12.2.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.4/kdenlive-19.12.2-segfault_fix-1.patch


NAME=kdenlive
VERSION=19.12.2
URL=http://download.kde.org/stable/release-service/19.12.2/src/kdenlive-19.12.2.tar.xz
SECTION="KDE Frameworks 5 Based Applications"
DESCRIPTION="The Kdenlive package is a KF5 based video editor."

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


patch -Np1 -i ../kdenlive-19.12.2-segfault_fix-1.patch
mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release         \
      -DBUILD_TESTING=OFF                \
      -Wno-dev .. &&
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

