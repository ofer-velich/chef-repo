#!/bin/bash

# move to the script's dir
if [ ! -f $1 ]; then
    echo $1 not found
    exit 1
fi
DIRNAME=$(dirname $1) 
FILENAME=$(basename $1)
PWD=$(pwd)
pushd $DIRNAME > /dev/null 2>&1


# execute the command provided as-is
shift
./${FILENAME} ${@}
RETVAL=$?

# restore location
popd > /dev/null 2>&1

