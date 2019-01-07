#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libtirpc
#REQ:rpcsvc-proto
#OPT:nfs-utils
#OPT:libxml2
#OPT:mitkrb
#OPT:openldap
#OPT:cyrus-sasl

cd $SOURCE_DIR

wget -nc https://www.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.1.5.tar.xz

NAME=autofs
VERSION=5.1.5
URL=https://www.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.1.5.tar.xz

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

./configure --prefix=/ \
--with-libtirpc \
--with-systemd \ 
--without-openldap \
--mandir=/usr/share/man &&

make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mv /etc/auto.master /etc/auto.master.bak &&
cat > /etc/auto.master << "EOF"
# Begin /etc/auto.master

/media/auto /etc/auto.misc --ghost
#/home /etc/auto.home

# End /etc/auto.master
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl enable autofs
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
