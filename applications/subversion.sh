#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:apr-util
#REQ:sqlite
#REC:serf
#OPT:apache
#OPT:cyrus-sasl
#OPT:dbus
#OPT:libsecret
#OPT:python2
#OPT:ruby
#OPT:swig
#OPT:openjdk
#OPT:junit

cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/subversion/subversion-1.10.3.tar.bz2

URL=https://archive.apache.org/dist/subversion/subversion-1.10.3.tar.bz2

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

./configure --prefix=/usr             \
            --disable-static          \
            --with-apache-libexecdir  \
            --with-lz4=internal       \
            --with-utf8proc=internal &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&

install -v -m755 -d /usr/share/doc/subversion-1.10.3 &&
cp      -v -R       doc/* \
                    /usr/share/doc/subversion-1.10.3
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
