#!/bin/bash

#making sure the first argument is a number.
re='^[0-9]+$'
if ! [[ $1 =~ $re ]] ; then
   echo "error: Not a number"
   exit 1
fi

let TIMES_EXECUTED=0
let TIMES_TO_EXECUTE=$1

shift

while [  $TIMES_EXECUTED -lt $TIMES_TO_EXECUTE ]; do
    ${@}&
    let  TIMES_EXECUTED=$TIMES_EXECUTED+1 
done

let GREP_RESULT=`ps aux | grep "${@}" | wc -l`
while [ $GREP_RESULT -gt 2  ]; do
    sleep 2
    #echo `ps aux | grep "${@}" | wc -l`
    #echo $GREP_RESULT
    GREP_RESULT=`ps aux | grep "${@}" | wc -l`
done
exit 0


