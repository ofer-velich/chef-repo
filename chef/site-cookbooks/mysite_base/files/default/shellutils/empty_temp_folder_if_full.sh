#!/bin/bash

#Deleting all files and folders from beehive temp folder, if it's capacity is 95% or more.

PERCENTAGE=`df -h | grep /beehive_tmp | awk '{print $5}' |  rev | cut -c 2- | rev`

if [ $PERCENTAGE -ge 95 ]
then
  sudo rm -Rf /beehive_tmp/*
fi
exit 0
