#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#OPT:db
#OPT:cracklib
#OPT:libtirpc
#OPT:docbook
#OPT:docbook-xsl
#OPT:fop
#OPT:libxslt
#OPT:w3m

cd $SOURCE_DIR

wget -nc http://linux-pam.org/library/Linux-PAM-1.3.0.tar.bz2
wget -nc http://linux-pam.org/documentation/Linux-PAM-1.2.0-docs.tar.bz2

NAME=linux-pam
VERSION=1.3.0.
URL=http://linux-pam.org/library/Linux-PAM-1.3.0.tar.bz2

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

tar -xf ../Linux-PAM-1.2.0-docs.tar.bz2 --strip-components=1
./configure --prefix=/usr                    \
            --sysconfdir=/etc                \
            --libdir=/usr/lib                \
            --disable-regenerate-docu        \
            --enable-securedir=/lib/security \
            --docdir=/usr/share/doc/Linux-PAM-1.3.0 &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m755 -d /etc/pam.d &&

cat > /etc/pam.d/other << "EOF"
auth     required       pam_deny.so
account  required       pam_deny.so
password required       pam_deny.so
session  required       pam_deny.so
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
rm -fv /etc/pam.d/*
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
chmod -v 4755 /sbin/unix_chkpwd &&

for file in pam pam_misc pamc
do
  mv -v /usr/lib/lib${file}.so.* /lib &&
  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
done
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -vdm755 /etc/pam.d &&
cat > /etc/pam.d/system-account << "EOF" &&
<code class="literal"># Begin /etc/pam.d/system-account account required pam_unix.so # End /etc/pam.d/system-account</code>
EOF

cat > /etc/pam.d/system-auth << "EOF" &&
<code class="literal"># Begin /etc/pam.d/system-auth auth required pam_unix.so # End /etc/pam.d/system-auth</code>
EOF

cat > /etc/pam.d/system-session << "EOF"
<code class="literal"># Begin /etc/pam.d/system-session session required pam_unix.so # End /etc/pam.d/system-session</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/pam.d/system-password << "EOF"
<code class="literal"># Begin /etc/pam.d/system-password # check new passwords for strength (man pam_cracklib) password required pam_cracklib.so type=Linux retry=3 difok=5 \ difignore=23 minlen=9 dcredit=1 \ ucredit=1 lcredit=1 ocredit=1 \ dictpath=/lib/cracklib/pw_dict # use sha512 hash for encryption, use shadow, and use the # authentication token (chosen password) set by pam_cracklib # above (or any previous modules) password required pam_unix.so sha512 shadow use_authtok # End /etc/pam.d/system-password</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/pam.d/system-password << "EOF"
<code class="literal"># Begin /etc/pam.d/system-password # use sha512 hash for encryption, use shadow, and try to use any previously # defined authentication token (chosen password) set by any prior module password required pam_unix.so sha512 shadow try_first_pass # End /etc/pam.d/system-password</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/pam.d/other << "EOF"
<code class="literal"># Begin /etc/pam.d/other auth required pam_warn.so auth required pam_deny.so account required pam_warn.so account required pam_deny.so password required pam_warn.so password required pam_deny.so session required pam_warn.so session required pam_deny.so # End /etc/pam.d/other</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
