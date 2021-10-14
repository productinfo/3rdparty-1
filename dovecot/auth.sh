#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )

exec ${DIR}/lib/ld.so --library-path ${DIR}/lib:${DIR}/lib/dovecot:${DIR}/lib/dovecot/stats ${DIR}/libexec/dovecot/auth.bin "$@"
