#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

echo "arch: $ARCH"

if [[ ${ARCH}=="x86_64" ]]; then
    NODE_ARCH=x64
else
    NODE_ARCH=${ARCH}
fi
export TMPDIR=/tmp
export TMP=/tmp
NAME=nodejs
VERSION=4.2.1
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}
NODE_ARCHIVE=node-v${VERSION}-linux-${NODE_ARCH}
apt-get -y install build-essential libncurses5-dev

rm -rf ${BUILD}
mkdir ${BUILD}
cd ${BUILD}

wget https://nodejs.org/dist/v${VERSION}/${NODE_ARCHIVE}.tar.gz \
    --progress dot:giga -O ${NAME}-${VERSION}.tar.gz
tar xzf ${NAME}-${VERSION}.tar.gz
mv ${NODE_ARCHIVE} ${NAME}

#./configure --prefix=${PREFIX}
#make
#make install

rm -rf ${BUILD}/${NAME}-${ARCH}.tar.gz
tar czf ${DIR}/${NAME}-${ARCH}.tar.gz -C ${BUILD} ${NAME}