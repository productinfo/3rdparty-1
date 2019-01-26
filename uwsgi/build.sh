#!/bin/bash


DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

export TMPDIR=/tmp
export TMP=/tmp

NAME=uwsgi
VERSION=2.0.13

echo "building ${NAME}"

apt-get -y install build-essential python-dev

rm -rf build
mkdir -p build
cd build

wget http://projects.unbit.it/downloads/${NAME}-${VERSION}.tar.gz --progress dot:giga
tar xzf ${NAME}-${VERSION}.tar.gz
cd ${NAME}-${VERSION}

sed -i 's/xml = auto/json = false/g' buildconf/base.ini
sed -i 's/json = auto/json = false/g' buildconf/base.ini
python uwsgiconfig.py --build

cd ../..
PREFIX=install/${NAME}

mkdir -p ${PREFIX}/bin
cp uwsgi.sh ${PREFIX}/bin
cp build/${NAME}-${VERSION}/uwsgi ${PREFIX}/bin
mkdir -p ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libz.so* ${PREFIX}/lib
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libuuid.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libssl.so* ${PREFIX}/lib
cp --remove-destination /usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypto.so* ${PREFIX}/lib 
cp --remove-destination /lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/libcrypt.so* ${PREFIX}/lib 

ldd ${PREFIX}/bin/uwsgi

export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/bin/uwsgi

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C install ${NAME}
