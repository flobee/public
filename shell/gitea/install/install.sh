#!/bin/sh

# ---------------------------------------------------------------------
# Paths/ settings you may want to change: see config.sh
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
# Basic includes for all scripts
# ---------------------------------------------------------------------
DIR_OF_FILE="$(dirname $(readlink -f "$0"))";
. ${DIR_OF_FILE}/shellFunctions.sh
sourceConfigs "${DIR_OF_FILE}" "config.sh-dist" "config.sh"
# ---------------------------------------------------------------------

# pre-install to check if required packages are available
sh ${DIR_OF_FILE}/pre-install.sh
if [ "$?" != 0 ]; then
    exit 1;
fi

# Download gitea bin
sh ${DIR_OF_FILE}/download.sh "$1"
if [ "$?" != 0 ]; then
    exit 1;
fi

echo '###';
echo '# installing gitea....';


adduser --system \
    --shell /bin/bash \
    --gecos 'Git Version Control' \
    --group --disabled-password \
    --home ${PATH_HOME} \
    ${USER}


mkdir -p "$PATH_REPOSITORIES"
chown ${USER}:${USER} "$PATH_REPOSITORIES"

mkdir -p "${PATH_HOME}/.ssh"
chown ${USER}:${USER} "${PATH_HOME}/.ssh"
chmod 700 "${PATH_HOME}/.ssh"
touch "${PATH_HOME}/.ssh/authorized_keys"
chown ${USER}:${USER} "${PATH_HOME}/.ssh/authorized_keys"
chmod 600 "${PATH_HOME}/.ssh/authorized_keys"


mkdir -p ${PATH_GITEA}
chown ${USER}:${USER} ${PATH_GITEA}

mkdir -p ${PATH_GITEA}/{custom,data,indexers,public,log}

echo '# install binary';
cp -f "/tmp/${GITEA_BIN_BASENAME}" "${PATH_GITEA}/gitea"
chmod +x "${PATH_GITEA}/gitea"


#
# preparing init service script
#
cat >/etc/systemd/system/gitea.service <<EOTEXT
[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target
After=network.target
#After=mysqld.service
#After=postgresql.service
#After=memcached.service
#After=redis.service

[Service]
# Modify these two values and uncomment them if you have
# repos with lots of files and get an HTTP error 500 because
# of that
###
#LimitMEMLOCK=infinity
#LimitNOFILE=65535
RestartSec=10s
Type=simple
User=${USER}
Group=${USER}
WorkingDirectory=${PATH_HOME}/tea
ExecStart=${PATH_GITEA}/gitea web -p $PORT -c ${PATH_GITEA}/custom/conf/app.ini
Restart=always
Environment=USER=${USER} HOME=${PATH_HOME} GITEA_WORK_DIR=${PATH_GITEA}
# If you want to bind Gitea to a port below 1024 uncomment
# the two values below
###
#CapabilityBoundingSet=CAP_NET_BIND_SERVICE
#AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target

EOTEXT


echo '---------------------------------------------------------------------';
echo "You should be in as user '${USER}' now! verify with eg: $: id";
echo 'Copy the following infomations because after starting the gitea server';
echo 'it will output an lot and then execute now to start the gitea server: ';
echo "    cd ${PATH_GITEA}";
echo "    ./gitea web -p ${PORT} -c custom/conf/app.ini"
echo
echo "If you just upgrade the binary: "
echo "Make sure the conf/app.ini is writable for the user '${USER}' if you want";
echo "to change settings! Otherwise just go ahead, see below";
echo
echo "New install: Now open your browser to http://<server>:${PORT} and follow";
echo "the instructions";
echo
echo 'Note: If you have an existing app.ini the values are NOT SHOWN';
echo 'It shows default values! Take care!';
echo
echo '    To help you a little (simple install):';
echo '    DB  : sqlite';
echo "    Path: ${PATH_GITEA}/data/gitea.db";
echo "    Path repos: ${PATH_REPOSITORIES}";
echo "    LFS: ${PATH_GITEA}/data/lfs ";
echo '';
echo ' Mail setup: Ask your admins!';
echo '---------------------------------------------------------------------';
echo "After it, close the session CRTL + C (stop gitea) then CRTL + D (out
of user ${USER}) to go ahead with this script";
echo '---------------------------------------------------------------------';

# first run of gittea should be under user ${USER}
su - ${USER}

if [ "$INSTALL_AS_SERVICE" = "1" ];
then
    # remove existing
    systemctl daemon-reload
    systemctl stop gitea
    systemctl disable gitea
    # re-add
    systemctl enable gitea
    systemctl daemon-reload
    systemctl start gitea
fi

. ${DIR_OF_FILE}/z_after_install_update.sh
