#!/bin/bash

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

action=$(echo $0 | cut -d '_' -f2 | cut -d '.' -f1);

if [ "$action" = "start" ] || [ "$action" = "status" ]; then
    sudo service rsyslog "$action"
    #sudo service syslog-ng "$action"; # eg. for wsl2/Ubuntu2204++
    sudo service ssh "$action";
    sudo service cron "$action";
    sudo service docker "$action";
    sudo service nginx "$action";

elif [ "$action" = "stop" ]; then
    # reverse order
    sudo service nginx "$action";
    sudo service docker "$action";
    sudo service cron "$action";
    sudo service ssh "$action";
    #sudo service syslog-ng "$action";
    sudo service rsyslog "$action"

else
    echo "Action '$action' not in.";
fi

exit 0
