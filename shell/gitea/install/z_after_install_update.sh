#!/bin/sh

# ---------------------------------------------------------------------
# Basic includes for all scripts
# ---------------------------------------------------------------------
DIR_OF_FILE="$(dirname $(readlink -f "$0"))";
. ${DIR_OF_FILE}/shellFunctions.sh
sourceConfigs "${DIR_OF_FILE}" "config.sh-dist" "config.sh"
# ---------------------------------------------------------------------

echo '---------------------------------------------------------------------';
echo "If you dont see any erros.. the service was removed, re-added and gitea
was started again. (If you run this script e.g for updates)

NOTE: gitea app.ini is temporary set with write rights for user $USER so that the
Web installer could write the configuration file.
After installation is done it is recommended to set rights to read-only to keep
the config secure. Please run:

    chmod 750 ${PATH_GITEA}/custom/conf/
    chmod 640 ${PATH_GITEA}/custom/conf/app.ini
    chown -R root:$USER ${PATH_GITEA}/custom/conf/

To check if the service is runing:
    systemctl status gitea.service

Checking migration status:
    tail -f ${PATH_GITEA}/log/gitea.log

Happy git + tea :)
";
