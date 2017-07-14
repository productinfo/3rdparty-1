#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )
export LD_LIBRARY_PATH=${DIR}/lib
${DIR}/bin/python ${DIR}/bin/certbot "$@"
