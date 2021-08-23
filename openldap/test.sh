#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

${DIR}/build/openldap/sbin/slapadd.sh --help || true
${DIR}/build/openldap/bin/ldapadd.sh --help || true

export LD_LIBRARY_PATH=${DIR}/build/openldap/lib
mkdir ${DIR}/build/slapd.d
mkdir ${DIR}/build/data
sed -i "s#@ETC_DIR@#${DIR}/build/openldap/etc/openldap#g" ${DIR}/slapd.test.config.ldif
sed -i "s#@LIB_DIR@#${DIR}/build/openldap/libexec/openldap#g" ${DIR}/slapd.test.config.ldif
sed -i "s#@DB_DIR@#${DIR}/build/data#g" ${DIR}/slapd.test.config.ldif
${DIR}/build/openldap/sbin/slapadd -v -F ${DIR}/build/slapd.d -n 0 -l ${DIR}/slapd.test.config.ldif
${DIR}/build/openldap/sbin/slapadd -v -F ${DIR}/build/slapd.d -l ${DIR}/slapd.test.db.ldif
