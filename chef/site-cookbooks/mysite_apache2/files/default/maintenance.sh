#!/bin/bash


function usage {
        SCRIPT_NAME=`basename $1`
        echo Move all listed sites in to OR out from maintenance mode.
        echo
        echo Usage:
        echo     $SCRIPT_NAME -m MODE -s SITE -s SITE
        echo Example:
        echo     $SCRIPT_NAME -m disable -s api.mysite.com -s mysite.com
	echo     $SCRIPT_NAME -m enable -s api.mysite.com -s mysite.com
}

function disable_site {
	echo "Disabling site: $1"
	toggle_site $1 a2dissite
}

function enable_site {
	echo "Enabling site: $1"
	toggle_site $1 a2ensite
}

function toggle_site {
	site=$1
	action=$2
        sudo ${action} ${site} > /dev/null

        if [ $? != 0 ]; then
                echo "Failed to ${action} the site: ${site}"
        fi
}

function disable_filter {
	site=$1
    	enabled=`echo | ls /etc/apache2/sites-enabled/ | sed 's/ /\n /g'`
	if echo "${enabled}" | grep -q ^"${site}"$; then
               FILTERED_SITES+=( "${site}" )
        fi
}

function enable_filter {
	site=$1
        enabled=`echo | ls /etc/apache2/sites-enabled/ | sed 's/ /\n /g'`
	if ! echo "${enabled}" | grep -q ^"${site}"$; then
                FILTERED_SITES+=( "${site}" )
        fi
}


MAINTENANCE_SITE="000-maintenance.mysite.com.conf"
MANAGED_SITES=()
MODE="empty"

while getopts "m:s:h" OPTION
do
     case $OPTION in
                h)
                        usage $0
                        exit 1
			;;
                m)
                        MODE=`echo $OPTARG | tr '[:upper:]' '[:lower:]'`
			if [ $MODE == "disable" ]; then
				REVERSED_MODE="enable"
			else
                                REVERSED_MODE="disable"
			fi

			;;
                s)
			if [[ $OPTARG != "$MAINTENANCE_SITE" ]]; then
                        	MANAGED_SITES+=( "${OPTARG}.conf" )
                        fi
                	;;
		?)
                        usage $0
                        exit
			;;
     esac
done

# Validate that $mode variable has been set
if [[ $MODE != "disable" ]] && [[ $MODE != "enable" ]]; then
	usage $0
	exit 1
fi

# Validate that sites array has been set
if [ ${#MANAGED_SITES[@]} -eq 0 ]; then
        usage $0
        exit 1
fi

FILTERED_SITES=()

# Loop over all listed sites and validate that thay are exist
for site in ${MANAGED_SITES[@]}
do
	AVAILABLE_SITES=`echo | ls /etc/apache2/sites-available/ | sed 's/ /\n /g'`
	
	if echo "${AVAILABLE_SITES}" | grep -q ^"${site}"$; then
		${MODE}_filter ${site}
	fi
done

if [[ "${#FILTERED_SITES[@]}" == 0 ]]; then
	echo "No site, has benn found, exit..."
	exit 0
fi

# Loop over all listed sites and disable OR enable according to the $mode variable
for site in ${FILTERED_SITES[@]}
do
	${MODE}_site ${site}
done

# Disable OR enable the maintenance site according to the $mode variable
${REVERSED_MODE}_site ${MAINTENANCE_SITE}

#sudo apache2ctl graceful
echo "restat apache (graceful)"
sudo /etc/init.d/apache2 graceful > /dev/null


exit 0

