#!/usr/bin/env php
<?php


/**
 * Git alias generator - php version
 *
 * # @autor Florian Blasel
 *
 * Executes shell commands to update/remove or init git aliases to
 * global ~/.gitconfig (your user)
 * When runnin as root:
 *  - 'system' (system wide (/etc)),
 *  - 'global' (current user/ your user (you|root)),
 *  - 'local' (current repo)
 * can be handled.
 * To be used in bash or zsh... to have 'git aliases'
 *
 * Including own helper aliases for daily business.
 *
 * Examples what this script does, eg:
 *      git config --global alias.visual '!gitk' # git visual
 *      git config --global --unset alias.visual # dropped in 'drop' to unset
 *
 * Requires: php-cli package (apt install php-cli)
 */


function gitaliases( $test, $configFile = false )
{
    // workflow: cleanup -> or drop/ remove -> add aliases
    $aliases = array(
        'cleanup' => array(
            // removes all aliases from $(prefix)/etc/gitconfig
            'system' => false,

            // removes all aliases from $HOME/.gitconfig
            'global' => false,

            // removes all aliases from the current project .git/config
            'local' => false,
        ),

        'drop' => array(
            // removes aliases from $(prefix)/etc/gitconfig (probably only for
            // root user)
            'system' => array(
            ),

            // removes aliases from $HOME/.gitconfig
            'global' => array(
                'last' => true, // set to true to delete this line!
                'll' => true,
                'l' => true,
                'llog' => true,
                'llogxx' => true,
                'logfind' => true,
                'verbose' => true,
                'repos' => true,
                'iDontWantThisAliasAnymore' => true, # to global blacklist the key or to be recreated afterwards
            ),

            // removes aliases from the current project .git/config
            'local' => array(),
        ),

        'add' => array(
            // adds aliases to $(prefix)/etc/gitconfig (probably only root can
            // do this) if you see some here and you are not the first user,
            // they may be already available for you
            // system wide means: limit it to save and known and working commands all over the time
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
                'dfs '=> 'diff --staged',
                'unstage' => 'reset HEAD',

                'undo-notpushed' => '!git reset HEAD~1 --soft',

                /* git alias : list all aliases
                 * useful in order to learn git syntax */
                'alias' => '!git config --list | grep alias | cut -c 7-',
                // push and pull all
                'pa' => '!git push --all && git pull --all',
                'aa' => '!git add -A',
                #'pl' => 'pull',
                'aa' => '!git add --update',
                'pl' => 'pull -v',
                'ps' => 'push',
                #'all' => '!git add . && git commit',

                'ls' => 'stash list',
                #'save' => 'stash save',
                #'pop' => 'stash pop',

                // --- showing logs ---
                'verbose' => "log --graph --stat '--pretty=format:Author of %C(red)%h%Creset was %C(green)%an%Creset, %C(auto,yellow)%ar%Creset, message was:\n%s\n%b\n%Creset'",
                #'l' => 'log --format=\'%C(red)%h%Creset %C(green)%an%Creset - %C(yellow)%s%Creset\' --graph',

                #202311: %cd respects --date setting, now iso strict
                'll' => 'log --pretty=format:\'%C(red)%h%Creset%C(blue)%d %C(green)%an%Creset - %s %C(yellow)(%cd)%Creset\' --graph --date=iso8601-strict',

                #202311: %cd respects --date setting, now iso strict
                'llog' => "log --graph --stat '--pretty=format:Author of %Cred%h%Creset was %C(green)%ae%Creset, %C(yellow)%cd%Creset, message:\n%C(auto)%s\n%b\n%Creset' --date=iso8601-strict",

                //'last' => "log -5 --graph --stat --pretty=format:'Author of %Cblue%h%Creset was %C(yellow)%an%Creset, %C(blue)%ar%Creset, message was\n%C(yellow)%s\n%b\n%Creset'",
                'last' => 'log -5 --pretty=format:\'%C(red)%h%Creset%C(auto)%d %C( green)%an%Creset - %s %C(yellow)( %cr)%Creset\' --graph --date=relative',

                // search for a term in full history
                // More hints: https://www.w3docs.com/snippets/git/how-to-find-a-deleted-file-in-the-project-commit-history.html
                'logfind' => '!git llog --all --full-history -- ',

                // playground, #202311: %cd respects --date setting, now iso lazy
                'llogxx' => "log --graph --stat '--pretty=format:Author of %Cred%h%Creset was %C(green)%ae%Creset, %C(yellow)%cd%Creset, message:\n%C(auto)%s\n%b\n%Creset' --date=iso",

                #'continue' => '!git add . && git rebase --continue',
                #'url' => 'config --local --get-regexp remote\\.\\.\\*\\.url',

                'amend' => 'commit --amend',

                // git drymerge <branch>
                'drymerge' => '!git merge --no-commit --squash ',

                'svnupdate' => '!git svn fetch && git svn rebase',
                'svncommit' => '!git svn dcommit',

                #'patch' => 'add --patch',
                #'cached' => '!git diff --cached --',
                'discard' => '!git checkout -- ',
                #local = branch --list
                'visual'  => '!gitk',

                'tags' => '!git tag',
                # latest tag (if tags available and maintained)
                'latestTag' => '!git describe --tags `git rev-list --tags --max-count=1`',

                // https://stackoverflow.com/questions/11981716/how-to-quickly-find-all-git-repos-under-a-directory
//                'repos' => "! \"find ~/workspace -type d -execdir test -d {}/.git \\\; -prune -print\"",
//                // nedded: repos =  !"find -type d -execdir test -d {}/.git \\; -prune -print"
//                //tux[1|2]deb: reposorg =  !"find ~/workspace -type d -execdir test -d {}/.git \\; -prune -print"
//

                ######################
                #Submodules aliases
                ######################

                # submodules aliases
                # 'sm-last' => '! git last && git submodule foreach \'git last\' ',

                #git sm-trackbranch : places all submodules on their respective branch specified in .gitmodules
                #This works if submodules are configured to track a branch, i.e if .gitmodules looks like :
#               #[submodule "my-submodule"]
#               #   path = my-submodule
#               #   url = git@wherever.you.like/my-submodule.git
#               #   branch = my-branch
                # 'sm-trackbranch' => '! git submodule foreach -q --recursive \'branch="\$(git config -f $toplevel/.gitmodules submodule.$name.branch)"; git checkout $branch\'',

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
                #'sm-pullrebase' => '! git pull --rebase; git submodule update; git sm-trackbranch ; git submodule foreach \'git pull --rebase\' ',

                # git sm-diff will diff the master repo *and* its submodules
                'sm-diff' => '! git diff && git submodule foreach \'git diff\'',

                #git sm-push will ask to push also submodules
                #'sm-push' => 'push --recurse-submodules=on-demand',

                //'sm-stat' => "! git status && git submodule foreach 'git status' "
            ),

            //
            // adds aliases to the current project .git/config
            'local' => array(

            ),
         ),
    );

    $json = json_encode( $aliases, JSON_PRETTY_PRINT );
    file_put_contents( './mk_git_aliases.json.tmp', $json );

    foreach ( $aliases as $job => $list ) {

        foreach( $list as  $way => $commands ) {

            if ( $way == 'system' && $_SERVER['USER'] != 'root' ) {
                // echo 'skip, not root' . PHP_EOL;
                continue;
            }

            if ( $way == 'local' ) {
                $way = '--local';
            } else {
                $way = '--' . $way;
            }

            switch ( $job )
            {
                case 'cleanup':
                    if ( $commands===true ) {
                            echo '"cleanup" not implemented yet';
                    }
                    break;

                case 'drop':
                    foreach ( $commands as $alias => $cmd ) {
                       if ( $cmd === true ) {
                           $execlist[] = 'git config ' . $way . ' --unset alias.' . $alias;
                       }
                   }
                   break;

                case 'add':
                    foreach ( $commands as $alias => $cmd ) {
                        $execlist[] = 'git config ' . $way . ' alias.' . $alias . ' "' . $cmd .'"';
                    }
                break;
            }
        }
    }

    foreach ( $execlist as $cmd ) {
        if ( $test === false ) {
            $x = exec( $cmd, $data, $exitCode );
            if ( $x || $data || $exitCode > 5 ) {
                echo 'Problem? cmd: ' . $cmd . PHP_EOL;
                echo (empty( $x ) ? '0' : $x) . " || data || $exitCode" . PHP_EOL;
            }
            if ( $exitCode == 255 ) {
                echo 'ERROR: permission problem with: ' . $cmd . PHP_EOL;
            }
        }
        else {
            echo $cmd . PHP_EOL;
        }
    }
}


$test = true;
if ( @$_SERVER['argv'][1] === 'run' ) {
    $test = false;
} else {
    echo '# To execute commands run: "php ' . basename( __FILE__ ) . ' run"' . PHP_EOL;
}

gitaliases( $test );

