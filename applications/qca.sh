#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:make-ca
#REQ:cmake
#REQ:qt5
#REQ:which


cd $SOURCE_DIR

wget -nc https://download.kde.org/stable/qca/2.3.2/qca-2.3.2.tar.xz


NAME=qca
VERSION=2.3.2
URL=https://download.kde.org/stable/qca/2.3.2/qca-2.3.2.tar.xz
SECTION="General Libraries"
DESCRIPTION="Qca aims to provide a straightforward and cross-platform crypto API, using Qt datatypes and conventions. Qca separates the API from the implementation, using plugins known as Providers."

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


sed -i 's@cert.pem@certs/ca-bundle.crt@' CMakeLists.txt
mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$QT5DIR            \
      -DCMAKE_BUILD_TYPE=Release                \
      -DQCA_MAN_INSTALL_DIR:PATH=/usr/share/man \
      .. &&
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

