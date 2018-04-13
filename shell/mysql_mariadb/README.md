# About

Helper scripts for the "[mydumper](https://github.com/maxbube/mydumper)" project
(apt-get install mydumper)

# Usage for admins
 
Download the files or checkout to hole repo.

Verify the following:

    chmod 7** dbs_restore_root.sh dbs_backup_root.sh
    chmod 6** dbs_dummy.cnf dbs_request_credentials.sh


I link the scripts to /root/scripts/

    ln -s /path/to/public/shell/mysql_mariadb/dbs_backup_root.sh /root/scripts/dbs_backup.sh
    ln -s /path/to/public/shell/mysql_mariadb/dbs_restore_root.sh /root/scripts/dbs_restore.sh
    ln -s /path/to/public/shell/mysql_mariadb/dbs_request_credentials.sh /root/scripts/


My backups are located here: /mnt/backups/host/dbs


## Run a backup

Usage:

    /to/dbs_backup.sh [cfg-file or backup-dir or no-parameter]

If no parameters or just a backup path was given you will be ask for all missing
values: backup path and db user/password...

    /to/dbs_backup.sh
    # or
    /to/dbs_backup.sh /mnt/backups/host/dbs
    # or
    /to/dbs_backup.sh /to/dbs_dummy.cfg


## Run a restore

Usage:

    /to/dbs_restore.sh <config|none> <dbs directory> [opt flag: show only commands, dont execute]

Demo commands:

    # you will be ask for credentials
    /to/dbs_restore.sh none /mnt/backups/host/dbs
    
    # no futher requests
    /to/dbs_restore.sh /to/dbs_dummy.cfg /mnt/backups/host/dbs
    
    # Shows only commands for each database.
    # You can execute it later or just for one, two.. databases
    /to/dbs_restore.sh none /mnt/backups/host/dbs true


## SECURITY WARNING

Use this script only in you private hood.
E.g. Only use remote connections or in your private network. Otherwise your users
can see your credentials when scanning the process lists.
I opened a ticket for this issue already. As good a i tested: The .my.cnf wasn't 
sourced in any way yet :(


Happy backuping and restoring :)