#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:frameworks5
#REQ:libkcddb
#REQ:libsamplerate
#REQ:shared-mime-info
#REQ:udisks2
#REQ:ffmpeg
#REQ:libburn
#REQ:libdvdread
#REQ:taglib
#REQ:cdrtools
#REQ:dvd-rw-tools
#REQ:cdrdao


cd $SOURCE_DIR

wget -nc https://download.kde.org/stable/release-service/20.12.2/src/k3b-20.12.2.tar.xz


NAME=k3b
VERSION=20.12.2
URL=https://download.kde.org/stable/release-service/20.12.2/src/k3b-20.12.2.tar.xz
SECTION="KDE Frameworks 5 Based Applications"
DESCRIPTION="The K3b package contains a KF5-based graphical interface to the Cdrtools and dvd+rw-tools CD/DVD manipulation tools. It also combines the capabilities of many other multimedia packages into one central interface to provide a simple-to-operate application that can be used to handle many of your CD/DVD recording and formatting requirements. It is used for creating audio, data, video and mixed-mode CDs as well as copying, ripping and burning CDs and DVDs."

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

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release         \
      -DBUILD_TESTING=OFF                \
      -Wno-dev ..                        &&
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

