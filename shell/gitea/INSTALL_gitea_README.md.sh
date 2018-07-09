#!/bin/bash
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Install script for gitea under debian stretch
#
# I had some issues at the very first day and was not able to get gitea run. 
# Basicly and then when using it as a service.
# The documentation is currently not good enough for me so this may help you 
# also.
#
# Install gitea under user "git" ? Read ahead :)
#
# Now you will find the list of commands you may execute by hand or running this 
# script. 
# It will guide you a little. First read all infomations of the output befor you 
# go on to avoid problems.
#
# It should be run under root and will setup needed path and rights and switch 
# the user when needed for setup/configure the frontend with furhter details.
#
# Hints: 
# forget your /home/git/.ssh/authorized_keys
# Gitea will do! bring it to zero bytes if alreayd exists and you will have 
# less issues :)
#
# --- Paths you may want to change: --------------------------------------------
PATH_HOME=/home/git
USER=git
PORT=3001
GITEA_BIN_URL=https://dl.gitea.io/gitea/master/gitea-master-linux-amd64
# ------------------------------------------------------------------------------

adduser --system \
    --shell /bin/bash \
    --gecos 'Git Version Control' \
    --group --disabled-password \
    --home $PATH_HOME \
    $USER


mkdir -p $PATH_HOME/repositories
chown $USER:$USER $PATH_HOME/repositories

mkdir -p $PATH_HOME/.ssh
chown $USER:$USER $PATH_HOME/.ssh
chmod 700 $PATH_HOME/.ssh
touch $PATH_HOME/.ssh/authorized_keys
chown $USER:$USER $PATH_HOME/.ssh/authorized_keys
chmod 600 $PATH_HOME/.ssh/authorized_keys


mkdir -p $PATH_HOME/tea
chown $USER:$USER $PATH_HOME/tea


# latest:
# https://dl.gitea.io/gitea/master/gitea-master-linux-amd64
# v1.4.2
# wget -O /tmp/gitea https://dl.gitea.io/gitea/1.4.2/gitea-1.4.2-linux-amd64
wget -O /tmp/gitea $GITEA_BIN_URL
mv /tmp/gitea $PATH_HOME/tea
chmod +x $PATH_HOME/tea/gitea


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
RestartSec=2s
Type=simple
User=$USER
Group=$USER
WorkingDirectory=$PATH_HOME/tea
ExecStart=$PATH_HOME/tea/gitea web -c custom/conf/app.ini
Restart=always
Environment=USER=$USER HOME=$PATH_HOME GITEA_WORK_DIR=$PATH_HOME/tea
# If you want to bind Gitea to a port below 1024 uncomment
# the two values below
###
#CapabilityBoundingSet=CAP_NET_BIND_SERVICE
#AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target

EOTEXT


echo '---------------------------------------------------------------------';
echo "You should be in as user '$USER' now! verify with eg: $: id";
echo 'Copy the following infomations because after starting the gitea server';
echo 'it will output an lot and then execute now to start the gitea server: ';
echo "    cd $PATH_HOME/tea";
echo "    ./gitea web -p $PORT -c custom/conf/app.ini"
echo
echo "If you just upgrade the binary: "
echo "Make sure the conf/app.ini is writable for the user '$USER'!";
echo
echo "Now open your browser to http://<server>:$PORT and follow the instructions";
echo '';
echo '    To help you a little (simple install):';
echo '    DB  : sqlite';   
echo "    Path: $PATH_HOME/tea/data/gitea.db";
echo "    Path repos: $PATH_HOME/repositories";
echo "    LFS: $PATH_HOME/tea/data/lfs ";
echo '';
echo ' Mail setup: Ask your admins!';
echo '---------------------------------------------------------------------';
echo 'After it, close the session CRTL + C (stop gitea) then CRTL + D (out 
of user git) to go ahead with this script';
echo '---------------------------------------------------------------------';

# first run of gittea should be under user $USER
su - $USER


# remove existing
systemctl daemon-reload
systemctl stop gitea
systemctl disable gitea
# re-add
systemctl enable gitea
systemctl daemon-reload
systemctl start gitea


echo '---------------------------------------------------------------------';
echo "If you dont see any erros.. the service was removed, re-added and gitea 
was started again. (If you run this script e.g for updates)

NOTE: gitea app.ini is temporary set with write rights for user $USER so that the
Web installer could write the configuration file.
After installation is done it is recommended to set rights to read-only to keep 
the config secure. Please run:

    chmod 750 $PATH_HOME/tea/custom/conf/
    chmod 640 $PATH_HOME/tea/custom/conf/app.ini
    chown -R root:$USER $PATH_HOME/tea/custom/conf/

To check if the service is runing:
    systemctl status gitea.service
    
Happy git + tea :)
";
