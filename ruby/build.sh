#!/bin/bash


DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export TMPDIR=/tmp
export TMP=/tmp
NAME=ruby
VERSION=2.1.5
ROOT=/opt/app/platform
PREFIX=${ROOT}/${NAME}

echo "building ${NAME}"

command curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -

#useradd -p ruby ruby

rm -rf /tmp/rvm

curl -sSL https://get.rvm.io | bash -s stable --path /tmp/rvm
source /tmp/rvm/scripts/rvm
rvm install ${VERSION} --movable
rm -rf ${DIR}/${NAME}.tar.gz

rm -rd ${DIR}/build
mkdir ${DIR}/build

cp -r /tmp/rvm/rubies/${NAME}-${VERSION} ${DIR}/build/ruby

tar cpzf ${DIR}/${NAME}.tar.gz -C ${DIR}/build ruby