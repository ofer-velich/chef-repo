#!/bin/bash

# git clone beaver
ROOT=/home/ubuntu

# move to working dir
pushd ${ROOT} > /dev/null

	sudo a2ensite healthcheck.conf
	sudo service apache2 reload

# restore location
popd > /dev/null

exit 0
