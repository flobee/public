#!/bin/sh

# usage: See README.md

DIR_OF_FILE="$(dirname $(readlink -f "$0"))";
. ${DIR_OF_FILE}/config.sh
cd ${PATH_HOME};

# VirtualBox autostart
#VBoxManage startvm 'giteavm' --type headless
#sleep 45; # wait for the VM is up

###
# Backup

if [ "${ACTION_ASKQUESTIONS}" = "Y" ]; then
    CONFIRMCOMMAND=${ACTION_BACKUPDEF};
    echo "Run backup bevor going on? (defaut: '${ACTION_ASKQUESTIONS}')";
    confirmCommand "${ACTION_BACKUPDEF}";
    if [ "$?" = 0 ] && [ ${CONFIRMCOMMAND} = "Y" ]; then
        sh ${DIR_OF_FILE}/backup.sh
    fi
fi

if [ "${ACTION_ASKQUESTIONS}" = "N" ] && [ "${ACTION_BACKUPDEF}" = "Y" ]; then
    sh ${DIR_OF_FILE}/backup.sh
fi



###
# Install/ Update

# request action type again?
if [ "${ACTION_ASKQUESTIONS}" = "Y" ]; then
    _ACTION_TYPE=${ACTION_TYPE};
    echo "Run install(I) or update(U) ? (defaut: '${ACTION_TYPE}')";
    read -p "install (I) or update (U) (def:'${_ACTION_TYPE}'): " ACTION_TYPE
    ACTION_TYPE=${ACTION_TYPE:-$_ACTION_TYPE}
fi

if [ "${ACTION_TYPE}" = 'U' ]; then
    echo 'Install variant: update';
    sh ${DIR_OF_FILE}/update.sh;
fi

if [ "${ACTION_TYPE}" = 'I' ]; then
    echo 'Install variant: install (new, all checks)';
    sh ${DIR_OF_FILE}/install.sh;
fi

if [ "${ACTION_TYPE}" != 'I' ] && [ "${ACTION_TYPE}" != 'U' ]; then
    echo "ACTION_TYPE invalid, check config, exit";
    exit 1;
fi



#
# finishing
#

echo 'done';

exit 0;
