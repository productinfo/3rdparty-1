#!/bin/bash -e
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
${DIR}/python ${DIR}/py.test "$@"
