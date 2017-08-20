#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

export TMPDIR=/tmp
export TMP=/tmp
NAME=postfix
VERSION=3.2.2
BUILD_DIR=./build
PREFIX=${DIR}/build/${NAME}
echo "building ${NAME}"

apt-get -y update
apt-get -y install build-essential libldap2-dev libsasl2-dev libssl-dev libldb-dev libdb-dev

rm -rf build
mkdir -p build
cd build

wget ftp://ftp.reverse.net/pub/postfix/official/${NAME}-${VERSION}.tar.gz --progress dot:giga
tar xf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}

rm -rf ${BUILD_DIR}

export CCARGS='-DDEF_CONFIG_DIR=\"/opt/app/mail/config/postfix\" \
	-DUSE_SASL_AUTH \
	-DDEF_SERVER_SASL_TYPE=\"dovecot\" \
  -I/usr/include -DHAS_LDAP \
  -DUSE_TLS'

export AUXLIBS="-L/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE) \
  -lldap -L/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE) \
  -llber -lssl -lcrypto"

make makefiles
make
make non-interactive-package install_root=${PREFIX}

mv ${PREFIX}/usr/sbin/postfix ${PREFIX}/usr/sbin/postfix.bin
cp ${DIR}/usr/sbin/* ${PREFIX}/usr/sbin

echo "original libs"
ldd ${PREFIX}/usr/sbin/postfix.bin

cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl*.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libreadline.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libhistory.so* ${PREFIX}/lib

echo "embedded libs"
export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/usr/sbin/postfix.bin

cd ../..

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C build/${NAME}-${VERSION}/${BUILD_DIR} ${NAME}
