#!/bin/sh

# ---------------------------------------------------------------------
# checking installed packages. Debian like systems/ OS's by default
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# Basic includes for all scripts
# ---------------------------------------------------------------------
DIR_OF_FILE="$(dirname $(readlink -f "$0"))";
. ${DIR_OF_FILE}/shellFunctions.sh
sourceConfigs "${DIR_OF_FILE}" "config.sh-dist" "config.sh"
# ---------------------------------------------------------------------

CMD_PKG_MANAGER_CHECK="${PKG_MANAGER} ${PKG_MANAGER_OPTS}" # eg check if curl is available: dpkg -s curl


if [ ! -x "`which ${PKG_MANAGER}`" ]; then
    echo '+ ---------------------------------------------------------------------';
    echo "| Default package manager '${PKG_MANAGER}' not available or not";
    echo "| installed or not a debian based OS.";
    echo '+ ---------------------------------------------------------------------';
    echo '| Please check this script or make the following packeages available ';
    echo '| for your OS:';
    echo "| Reqired: '${PACKAGES_REQUIRED}'";
    echo "| Optional: '${PACKAGES_OPTIONAL}'";
    echo '| exit.';
    exit 1;
fi


PACKAGES_REQUIRED_MISSING='';
for PACKAGE in ${PACKAGES_REQUIRED}; do
    if [ ! "`${CMD_PKG_MANAGER_CHECK} ${PACKAGE}`" ]; then
        PACKAGES_REQUIRED_MISSING="${PACKAGES_REQUIRED_MISSING} ${PACKAGE}";
    fi
done;


PACKAGES_OPTIONAL_MISSING='';
for PACKAGE in ${PACKAGES_OPTIONAL}; do
    if [ ! "`${CMD_PKG_MANAGER_CHECK} ${PACKAGE}`" ]; then
        PACKAGES_OPTIONAL_MISSING="${PACKAGES_OPTIONAL_MISSING} ${PACKAGE}";
    fi
done;


if [ "${PACKAGES_REQUIRED_MISSING}" != "" ] || [ "${PACKAGES_OPTIONAL_MISSING}" != "" ]; then
    echo '+ ---------------------------------------------------------------------';
    echo '| Please make sure the following packages are installed';

    if [ "${PACKAGES_REQUIRED_MISSING}" != "" ]; then
        echo "| E.g running:";
        echo "|     apt install ${PACKAGES_REQUIRED_MISSING}";
    fi

    if [ "${PACKAGES_OPTIONAL_MISSING}" != "" ]; then
        echo "| Optional packages:";
        echo "|     apt install ${PACKAGES_OPTIONAL_MISSING}";
    fi

    echo '+ ---------------------------------------------------------------------';
fi

if [ ${PACKAGES_STOP_ON_INCOMPLETE} = "Y" ] && [ "${PACKAGES_REQUIRED_MISSING}" != "" ]; then
    echo '+ ---------------------------------------------------------------------';
    echo "Config: PACKAGES_STOP_ON_INCOMPLETE=Y. Please install the packages";
    echo "first. Run installer.sh/ runner.sh after it again.";
    echo '+ ---------------------------------------------------------------------';
    exit 1;
fi

