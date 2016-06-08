#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

NAME=openssl
PREFIX=${DIR}/build/${NAME}
OPENSSL_VERSION=1.0.2h

apt-get install libffi-dev

rm -rf ${PREFIX}
mkdir -p ${PREFIX}
cd ${PREFIX}

curl -O https://openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar xvf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}

./config -Wl,--version-script=${DIR}/openssl.ld -Wl,-Bsymbolic-functions -fPIC shared

./config no-shared no-ssl2 -fPIC --prefix=${PREFIX}

make
make install

cd ${DIR}
rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
