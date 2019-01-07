#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:db
#OPT:linux-pam
#OPT:mitkrb
#OPT:mariadb
#OPT:openjdk
#OPT:openldap
#OPT:postgresql
#OPT:sqlite

cd $SOURCE_DIR

wget -nc https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.27/cyrus-sasl-2.1.27.tar.gz

NAME=cyrus-sasl
VERSION=2.1.27
URL=https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.27/cyrus-sasl-2.1.27.tar.gz

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

./configure --prefix=/usr \
--sysconfdir=/etc \
--enable-auth-sasldb \
--with-dbpath=/var/lib/sasl/sasldb2 \
--with-saslauthd=/var/run/saslauthd &&
make -j1

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -dm755 /usr/share/doc/cyrus-sasl-2.1.27/html &&
install -v -m644 saslauthd/LDAP_SASLAUTHD /usr/share/doc/cyrus-sasl-2.1.27 &&
install -v -m644 doc/html/*.html /usr/share/doc/cyrus-sasl-2.1.27/html &&
install -v -dm700 /var/lib/sasl
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install-saslauthd
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
