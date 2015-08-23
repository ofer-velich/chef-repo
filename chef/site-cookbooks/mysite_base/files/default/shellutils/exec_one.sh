#!/bin/bash

LOCK_FILE=/var/lock/exec_one_lock

(
    # try to acquire the lock in a non blocking way
    flock -n -e 200
    if [ $? -ne 0 ]; then
        echo process already running...
        exit 1
    fi

    # execute the command provided as-is
    "$@"

) 200>$LOCK_FILE

