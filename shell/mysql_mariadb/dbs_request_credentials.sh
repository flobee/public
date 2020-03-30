# Edit default credentials
_MYSQL_USER='root';
_MYSQL_PASS='';
_MYSQL_PORT='3306';
_MYSQL_HOST='localhost';
# depending on your setup, eg. synology mariadb5 and 10 need a socket or you
# get only v5 connections even if the port is different
# set to '' to not use sockets
_MYSQL_SOCK=''; #'-S /run/mysqld/mysqld10.sock';
#
# requesting credentials to your databases.
# requrires at best a root account with grant options
#
read -p "Enter MYSQL USER (default: '$_MYSQL_USER'): " MYSQL_USER
MYSQL_USER=${MYSQL_USER:-$_MYSQL_USER}

read -p "Enter MYSQL_PASS (default: '$_MYSQL_PASS'): " MYSQL_PASS
MYSQL_PASS=${MYSQL_PASS:-$_MYSQL_PASS}

read -p "Enter MYSQL_HOST (default: '$_MYSQL_HOST'): " MYSQL_HOST
MYSQL_HOST=${MYSQL_HOST:-$_MYSQL_HOST}

read -p "Enter MYSQL_PORT (default: '$_MYSQL_PORT'): " MYSQL_PORT
MYSQL_PORT=${MYSQL_PORT:-$_MYSQL_PORT}

read -p "Enter MYSQL SOCKET (eg: /run/mysqld/mysqld.sock; default: '$_MYSQL_SOCK'): " MYSQL_SOCK
MYSQL_SOCK=${MYSQL_SOCK:-$_MYSQL_SOCK}

