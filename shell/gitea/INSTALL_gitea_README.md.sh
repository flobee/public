#!/bin/bash
#
# List of command to get gitea run.
# 
# I had a lot of issues at the very first day and was not able to get gitea run. 
#
# Basicly and then when using it as a service.
#
# The documentation is not good enough for none real admins.
#
# Install under user "git" in /home/git ? Read ahead :)
#
# Now you will find the list of commands you may execute which should work on a 
# debian strech os.
# 
# It should be run under root and will setup needed path and rights and switch 
# the user when needed for setup/configure the frontend with furhter details.
# 
# hints: 
# forget your /home/git/.ssh/authorized_keys
# gitea will do! bring it to zero bytes and you will have less issues


adduser --system \
    --shell /bin/bash \
    --gecos 'Git Version Control' \
    --group --disabled-password \
    --home /home/git \
    git


mkdir -p /home/git/repositories
chown git:git /home/git/repositories


touch /home/git/.ssh/authorized_keys
chown git:git /home/git/.ssh/authorized_keys
chmod 600 /home/git/.ssh/authorized_keys


mkdir -p /home/git/tea
chown git:git /home/git/tea
# chmod 750 /home/git/tea/{data,indexers,log}
# mkdir /etc/gitea
# chown root:git /etc/gitea
# chmod 770 /etc/gitea

# latest:
# https://dl.gitea.io/gitea/master/gitea-master-linux-amd64
# v1.4.2
# wget -O /tmp/gitea https://dl.gitea.io/gitea/1.4.2/gitea-1.4.2-linux-amd64
wget -O /tmp/gitea https://dl.gitea.io/gitea/master/gitea-master-linux-amd64
mv /tmp/gitea /home/git/tea
chmod +x /home/git/tea/gitea


# cd /usr/local/bin
# ln -s /home/git/tea/bin/gitea .

#
# prepare init service script
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
RestartSec=2s
Type=simple
User=git
Group=git
WorkingDirectory=/home/git/tea/
ExecStart=/home/git/tea/gitea web -c /home/git/tea/custom/conf/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/home/git/tea
# If you want to bind Gitea to a port below 1024 uncomment
# the two values below
###
#CapabilityBoundingSet=CAP_NET_BIND_SERVICE
#AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target

EOTEXT


echo '---------------------------------------------------------------------';
echo 'You should be in as user "git" now! verify with eg: $> id';
echo 'Copy the following infomations because after starting the gitea server';
echo 'it will output an lot and then execute now to start the gitea server: ';
# run gitea under git user and setup using the browser
# git@server:~/tea$ ./gitea web -p 3001
# cd /home/git/tea
# ./gitea web -p 3001
echo '    cd /home/git/tea';
echo '    ./gitea web -p 3001'
echo 'Now open your browser to http://<server>:3001 and follow the instructions';
echo '';
echo '    To help you a little (simple install):';
echo '    DB  : sqlite';   
echo '    Path: /home/git/tea/data/gitea.db';
echo '    Path repos: /home/git/repositories';
echo '    LFS: /home/git/tea/data/lfs ';
echo '';
echo ' Mail setup: Ask your admins!';
echo '---------------------------------------------------------------------';
echo 'After it, close the session CRTL + C (stop gitea) then CRTL + D (out 
of user git) to go ahead with this script';
echo '---------------------------------------------------------------------';

# first run of git tea should be under user git
su - git


# remove existing
systemctl daemon-reload
systemctl stop gitea
systemctl disable gitea
# re-add
systemctl enable gitea
systemctl daemon-reload
systemctl start gitea


echo '---------------------------------------------------------------------';
echo 'If you dont see any erros.. the service was removed, re-added and gitea 
was started again. (If you run this script e.g for updates)

NOTE: gitea app.ini is temporary set with write rights for user git so that the
Web installer could write the configuration file. 
After installation is done it is recommended to set rights to read-only to keep 
the config secure. Please run:

    chmod 750 /home/git/tea/custom/conf/
    chmod 640 /home/git/tea/custom/conf/app.ini
    chown -R root:git /home/git/tea/custom/conf/

To check if the service is runing:
    systemctl status gitea.service
    
Happy git + tea :)
';

