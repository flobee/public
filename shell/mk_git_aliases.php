#!/usr/bin/env php 
<?php

# Git alias generator
#
# @autor Florian Blasel
#
# shell command to update/init git aliases to global ~/.gitconfig (your user)
# this will add aliases to gitconfig when using the bash function gitaliases
# examples:
#   git config --global alias.visual '!gitk'
#   git config --global --unset alias.visual

function gitaliases($test)
{
    // workflow: cleanup/purge -> or drop/ remove -> add aliases
    $aliases = array(
        'cleanup' => array(
            // removes all aliases from the current project .git/config
            'local' => false,
            // removes all aliases from $HOME/.gitconfig
            'global' => false,

            // removes all aliases from $(prefix)/etc/gitconfig
            'system' => false,
        ),
        'drop' => array(
            // removes aliases from the current project .git/config
            'local' => array(
            ),
            // removes aliases from $HOME/.gitconfig
            'global' => array(
                'last' => true, // set to true to drop or delete this line!
                'll' => true,
                'llog' => true,
            ),
            // removes aliases from $(prefix)/etc/gitconfig (probably only for root)
            'system' => array(
            ),
        ),
        'add' => array(
            // adds aliases to the current project .git/config
            'local' => array(),

            // adds aliases to $(prefix)/etc/gitconfig (probably only root can do this)
            // if you see some here and you are not the first user, they are already available for you :-)
            'system' => array(
                'co' => 'checkout',
                'ci' => 'commit',
                'st' => 'status -sb',
                'stat' => 'status',
                'br' => 'branch',
                'alias' => '!git config -l | grep alias | cut -c 7-',
                'df' => 'diff',
            ),

            // adds aliases to $HOME/.gitconfig
            'global' => array(
                'co' => 'checkout',
                'ci' => 'commit',
                'up' => 'pull -v',
                'st' => 'status -sb',
                'stat' => 'status',
                # todo 'stat-dir' => '! git-stat-dir.sh',
                'br' => 'branch',
                #'fall' => 'fetch --all',
                #'mr' => 'merge',
                'df' => 'diff',
                'unstage' => 'reset HEAD',
                /* git alias : list all aliases
                 * useful in order to learn git syntax */
                'alias' => '!git config -l | grep alias | cut -c 7-',
                // push and pull all
                'pa' => '!git push --all && git pull --all',
                #'pl' => 'pull',
                #'ps' => 'push',
                #'all' => '!git add . && git commit',

                #'ls' => 'stash list',
                #'save' => 'stash save',
                #'pop' => 'stash pop',

                // --- showing logs ---
                'verbose' => "log --graph --stat --pretty=format:'Author of %C(red)%h%Creset was %C(green)%an%Creset, %C(blue)%ar%Creset, message was \n%s\n%b\n%Creset'",
                // 'l' => 'log --format=\'%C(red)%h%Creset %C(green)%an%Creset - %C(yellow)%s%Creset\' --graph',
                'll' => 'log --pretty=format:\'%C(red)%h%Creset%C(blue)%d %C(green)%an%Creset - %s %C(blue)(%cr)%Creset\' --graph --date=relative',
                'llog' => "log --graph --stat --pretty=format:'Author of %Cblue%h%Creset was %C(yellow)%ae%Creset, %C(blue)%ar%Creset, message: \n%C(yellow)%s\n%b\n%Creset'",
                

                //'last' => "log -5 --graph --stat --pretty=format:'Author of %Cblue%h%Creset was %C(yellow)%an%Creset, %C(blue)%ar%Creset, message was\n%C(yellow)%s\n%b\n%Creset'",
                'last' => 'log -5 --pretty=format:\'%C(red)%h%Creset%C(blue)%d %C( green)%an%Creset - %s %C(blue)( %cr)%Creset\' --graph --date=relative',

                #'continue' => '!git add . && git rebase --continue',
                #'url' => 'config --local --get-regexp remote\\.\\.\\*\\.url',

                #'amend' => 'commit --amend',

                'svnupdate' => '!git svn fetch && git svn rebase',
                'svncommit' => '!git svn dcommit',

                #'patch' => 'add --patch',
                #'cached' => '!git diff --cached --',
                'discard' => '!git checkout -- ',
                #local = branch --list
                'visual'  => '!gitk',


                ######################
                #Submodules aliases
                ######################

                # submodules aliases
                'sm-last' => '! git last && git submodule foreach \'git last\' ',

                #git sm-trackbranch : places all submodules on their respective branch specified in .gitmodules
                #This works if submodules are configured to track a branch, i.e if .gitmodules looks like :
                #[submodule "my-submodule"]
                #   path = my-submodule
                #   url = git@wherever.you.like/my-submodule.git
                #   branch = my-branch
                'sm-trackbranch' => '! git submodule foreach -q --recursive \'branch="$(git config -f $toplevel/.gitmodules submodule.$name.branch)"; git checkout $branch\'',

                #sm-pullrebase :
                # - pull --rebase on the master repo
                # - sm-trackbranch on every submodule
                # - pull --rebase on each submodule
                #
                # Important note :
                #- have a clean master repo and subrepos before doing this !
                #- this is *not* equivalent to getting the last committed
                #  master repo + its submodules: if some submodules are tracking branches
                #  that have evolved since the last commit in the master repo,
                #  they will be using those more recent commits !
                #
                #  (Note : On the contrary, git submodule update will stick
                #to the last committed SHA1 in the master repo)
                #
                'sm-pullrebase' => '! git pull --rebase; git submodule update; git sm-trackbranch ; git submodule foreach \'git pull --rebase\' ',

                # git sm-diff will diff the master repo *and* its submodules
                'sm-diff' => '! git diff && git submodule foreach \'git diff\' ',

                #git sm-push will ask to push also submodules
                'sm-push' => 'push --recurse-submodules=on-demand',
            ),
         ),
    );

    foreach($aliases as $job => $list)
    {
        foreach($list as  $way => $commands)
        {
            if ($way == 'system' && $_SERVER['USER'] != 'root') {
                // echo 'skip, not root' . PHP_EOL;
                continue;
            }

            if ($way == 'local') {
                $way = '';
            } else {
                $way = ' --' . $way;
            }

            switch($job)
            {
                case 'cleanup':
                    if ($commands===true) {
                            echo '"cleanup" not implemented yet';
                        }
                    break;

                case 'drop':
                    foreach($commands as $alias => $cmd) {
                       if ($cmd===true) {
                           $execlist[] = 'git config' . $way . ' --unset alias.' . $alias;
                       }
                   }
                   break;

                case 'add':
                    foreach($commands as $alias => $cmd) {
                        $execlist[] = 'git config' . $way . ' alias.' . $alias . ' "' . $cmd .'"';
                    }
                break;
            }
        }
    }

    foreach($execlist as $cmd)
    {
        if ($test === false)
        {
            $x = exec($cmd, $data, $exitCode);
            if ( $x || $data || $exitCode > 5 ) {
                echo 'Problem? cmd: ' . $cmd . PHP_EOL;
                echo (empty($x) ? '0':$x) . " || data || $exitCode" . PHP_EOL;
            }
            if ($exitCode == 255) {
                echo 'ERROR: permission problem with: '. $cmd . PHP_EOL;
            }
        } else {
            echo $cmd . PHP_EOL;
        }
    }
}


$test = true;
if (@$_SERVER['argv'][1] == 'run') {
    $test = false;
    //echo 'Will execute commands...' . PHP_EOL;
}

gitaliases($test);
