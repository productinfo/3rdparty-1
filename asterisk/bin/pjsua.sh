#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
LD_LIBRARY_PATH=${DIR}/lib
${DIR}/pjsua $@