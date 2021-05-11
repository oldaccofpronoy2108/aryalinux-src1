#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:nettle
#REQ:make-ca
#REQ:libunistring
#REQ:libtasn1
#REQ:p11-kit


cd $SOURCE_DIR

wget -nc https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.1.tar.xz
wget -nc ftp://ftp.gnupg.org/gcrypt/gnutls/v3.7/gnutls-3.7.1.tar.xz


NAME=gnutls
VERSION=3.7.1
URL=https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.1.tar.xz
SECTION="Security"
DESCRIPTION="The GnuTLS package contains libraries and userspace tools which provide a secure layer over a reliable transport layer. Currently the GnuTLS library implements the proposed standards by the IETF's TLS working group. Quoting from the TLS protocol specification:"

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


./configure --prefix=/usr \
            --docdir=/usr/share/doc/gnutls-3.7.1 \
            --disable-guile \
            --disable-rpath \
            --with-default-trust-store-pkcs11="pkcs11:" &&
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
make -C doc/reference install-data-local
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

