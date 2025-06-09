# Git alias generator

Executes shell commands to update/remove or init git aliases to

+ 'system' (system wide (`/etc`)), when runnin as root

+ 'global' (current user/ your user (you)) to `~/.gitconfig`

+ 'local' (current repo) `./.git/config`

can be handled.

To be used in CLI to have `git aliases` command and the configured
aliases available.

Including own helper aliases for daily business.

Configuration in `mk_git_aliases.shared-config.json5` by default.

Examples what this script does, eg:

    git config --global alias.visual '!gitk' # git visual
    git config --global --unset alias.visual # dropped in 'drop' to unset


There are several script (nodejs, php currently) which use the shared json5
config: `mk_git_aliases.shared-config.json5`


Custom config:

Create your config file: `mk_git_aliases.config-custom.json5` which will be
used instead of the default onfiguration file.


## PHP context

Install (Needs composer: <https://getcomposer.org/>):

    cd ./
    # install dependencies
    composer install

Usage:

    # Shows what it can do for you
    php mk_git_aliases.php

    # Executes and writes git aliases
    php mk_git_aliases.php run


## Node.js context

Install:

    # Requires node packages
    sudo apt install nodejs node-json5

or get [nvm](https://github.com/nvm-sh/nvm) to have node in user space.
BUT: you need json5 package local (here in ./).

Usage:

    # Shows what it can do for you
    nodejs ./mk_git_aliases.node.js

    # Executes and writes git aliases
    nodejs ./mk_git_aliases.node.js run
