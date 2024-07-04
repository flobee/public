#!/bin/bash

SCRIPT_DIRECTORY_REAL="$(dirname "$(readlink -f "$0")")";

###
# WSL services start/stop/status helper.
#
# Enable/disable the services you may need. (install and config of the services
# are up to you. This one is an example.)
#
# Starting the services when start via cmd.exe wsl command or clicking on a wsl
# (Ubuntu, Debian) starter icon: Add a start check in .bash_login or .zlogin
# file to run the starter script services_start.sh. E.g:
# -->--
#    # By default: dont start services listed below
#    _SERVICES_START=0;
#    # the location for the services_start.sh script.
#    _SERVICES_SCRIPT_START="/path/to/the/start/script/services_start.sh";
#
#    echo "Start WSL services '$_SERVICES_SCRIPT_START'? (0=no,1=yes,default: '$_SERVICES_START'):";
#    read -r SERVICES_START;
#    SERVICES_START=${SERVICES_START:-$_SERVICES_START};
#
#    if [ "$SERVICES_START" -eq 1 ]; then
#       $_SERVICES_SCRIPT_START
#    else
#        echo 'Skip starting services script';
#    fi
# --<--
# Install: Use this location or copy the files to your path and then:
# chmod 0644 services_.sh           # script logic
# chmod 0755 services_start.sh      # run start
# chmod 0755 services_stop.sh       # run stop
# chmod 0755 services_status.sh     # run status
#
#
# load configs: core and custom
#
# The lines make variable $SERVICES_LIST_START available
# shellcheck disable=SC1091
source "services_config.sh";

if [ -f "${SCRIPT_DIRECTORY_REAL}/services_config_custom.sh" ]; then
    # shellcheck disable=SC1091
    source "services_config_custom.sh";
else
    echo "File 'services_config_custom.sh' not found.";
    echo "Please create and setup (check 'services_config.sh')! Exit";
    exit 1;
fi


# $1 string service name
# $2 string action to perform
function do_check_run_service() {
    service=$(sudo which "$1");
    if [ "$service" != "" ]; then
        echo "Do $2 service: $1";
        sudo service "$1" "$2";
    fi;
}


action=$(echo "$0" | cut -d '_' -f2 | cut -d '.' -f1);

echo "Using 'sudo' command. You may will be asked for your password several times";
if [ "$action" = "start" ] || [ "$action" = "status" ]; then
    # forward loop
    for ((i=0; i<=${#SERVICES_LIST_START[@]}-1; i++)); do
        do_check_run_service "${SERVICES_LIST_START[$i]}" "$action";
    done;
elif [ "$action" = "stop" ]; then
    # reverse loop
    for ((i=${#SERVICES_LIST_START[@]}-1; i>=0; i--)); do
        do_check_run_service "${SERVICES_LIST_START[$i]}" "$action";
    done;
else
    echo "Action '$action' not in.";
fi

exit 0
