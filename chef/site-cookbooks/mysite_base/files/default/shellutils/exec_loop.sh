#!/bin/bash

RETVAL=0

while [[ $REVAL -eq 0 ]]; do
    $@
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        break;
    fi
done

exit $RETVAL
