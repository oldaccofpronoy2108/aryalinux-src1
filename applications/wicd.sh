#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:python2
#REQ:python-modules#dbus-python
#REQ:wireless_tools
#REQ:net-tools
#REC:python-modules#pygtk
#REC:wpa_supplicant
#REC:dhcpcd
#REC:dhcp
#OPT:pm-utils

cd $SOURCE_DIR

wget -nc https://launchpad.net/wicd/1.7/1.7.4/+download/wicd-1.7.4.tar.gz

URL=https://launchpad.net/wicd/1.7/1.7.4/+download/wicd-1.7.4.tar.gz

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

sed -e "/detection failed/ a\                self.init='init/default/wicd'" \
    -i.orig setup.py &&

rm po/*.po           &&

python setup.py configure --no-install-kde     \
                          --no-install-acpi    \
                          --no-install-pmutils \
                          --no-install-init    \
                          --no-install-gnome-shell-extensions \
                          --docdir=/usr/share/doc/wicd-1.7.4

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl enable wicd
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
