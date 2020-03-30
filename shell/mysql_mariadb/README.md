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

If no parameters or just a backup directory was given you will be ask for all
missing values: backup dir, user, password...

    /to/dbs_backup.sh
    # or
    /to/dbs_backup.sh /mnt/backups/host/dbs
    # or
    /to/dbs_backup.sh /to/dbs_dummy.cfg


## Run a restore

Usage:

    /to/dbs_restore.sh <config-file|'none'> [dbs directory] [opt flag: show only commands, dont execute]

Demo commands:

    # you will be ask for missing options like credentials or feature options:
    /to/dbs_restore.sh
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
I opened a ticket for this issue already. As good as i tested: The .my.cnf wasn't 
sourced in any way yet :(


# License

BSD 3-Clause License

Copyright (c) 2018, Florian Blasel All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

    Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



Happy backuping and restoring :)
