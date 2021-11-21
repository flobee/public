#!/bin/sh

# usage: See README.md

# ---------------------------------------------------------------------
# Basic includes for all scripts
# ---------------------------------------------------------------------
DIR_OF_FILE="$(dirname $(readlink -f "$0"))";
. ${DIR_OF_FILE}/shellFunctions.sh
sourceConfigs "${DIR_OF_FILE}" "config.sh-dist" "config.sh"
# ---------------------------------------------------------------------

cd ${PATH_HOME};

# VirtualBox autostart
#VBoxManage startvm 'giteavm' --type headless
#sleep 45; # wait for the VM is up

###
# Backup

if [ "${ACTION_ASKQUESTIONS}" = "Y" ]; then
    CONFIRMCOMMAND=${ACTION_BACKUPDEFAULT};
    echo "Run backup bevor going on? (defaut: '${ACTION_ASKQUESTIONS}')";
    confirmCommand "${ACTION_BACKUPDEFAULT}";
    if [ "$?" = 0 ] && [ ${CONFIRMCOMMAND} = "Y" ]; then
        sh ${DIR_OF_FILE}/backup.sh
    fi
fi

if [ "${ACTION_ASKQUESTIONS}" = "N" ] && [ "${ACTION_BACKUPDEFAULT}" = "Y" ]; then
    sh ${DIR_OF_FILE}/backup.sh
fi



###
# Install/ Update

# request action type again?
if [ "${ACTION_ASKQUESTIONS}" = "Y" ]; then
    _ACTION_TYPE=${ACTION_TYPE};
    echo "Run install (I) or update (U) ? (defaut: '${ACTION_TYPE}')";
    read -p "install (I) or update (U) (def:'${_ACTION_TYPE}'): " ACTION_TYPE
    ACTION_TYPE=${ACTION_TYPE:-$_ACTION_TYPE}
fi

if [ "${ACTION_TYPE}" = 'U' ]; then
    echo 'Install variant: update';
    sh ${DIR_OF_FILE}/update.sh "$1";
fi

if [ "${ACTION_TYPE}" = 'I' ]; then
    echo 'Install variant: install (new, all checks)';
    sh ${DIR_OF_FILE}/install.sh "$1";
fi

if [ "${ACTION_TYPE}" != 'I' ] && [ "${ACTION_TYPE}" != 'U' ]; then
    echo "ACTION_TYPE invalid, check config, exit";
    exit 1;
fi



#
# finishing
#

echo 'end';

exit 0;
