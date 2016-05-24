#!/bin/bash -x

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

VERSION=2.7.10

export TMPDIR=/tmp
export TMP=/tmp

NAME=python
PREFIX=${DIR}/build/${NAME}

apt-get -y install build-essential flex bison libreadline-dev zlib1g-dev libpcre3-dev libssl-dev libbz2-dev

rm -rf build
mkdir build
cd ${DIR}/build
wget https://github.com/yyuu/pyenv/archive/master.zip
unzip master.zip
export PYTHON_CONFIGURE_OPTS="--enable-shared --enable-unicode=ucs4"
./pyenv-master/plugins/python-build/bin/python-build ${VERSION} ${PREFIX}

mv ${PREFIX}/bin/python ${PREFIX}/bin/python.bin
cp ${DIR}/python ${PREFIX}/bin/

mv ${PREFIX}/bin/pip ${PREFIX}/bin/pip_runner
cp ${DIR}/pip ${PREFIX}/bin/

find ${PREFIX}/bin -type f -exec sed -i "s#${PREFIX}/##g" {} \;

cd ${DIR}

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}