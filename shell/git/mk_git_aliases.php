#!/usr/bin/env php
<?php

/**
 * Git alias generator - php version
 *
 * # @autor Florian Blasel
 *
 * Executes shell commands to update/remove or init git aliases
 *
 * Check: mk_git_aliases.README.md for more.
 */

if ( ! file_exists( __DIR__ . '/vendor/autoload.php') ) {
    echo 'Please use composer to install dependencies:' . PHP_EOL;
    echo 'get composer: https://getcomposer.org/' . PHP_EOL;
    echo 'cd . && composer install' . PHP_EOL;

    exit( 99 );
} else {
    require_once __DIR__ . '/vendor/autoload.php';
}

/**
 * TODO: for cleanup and drop to be used!!
 */
function generateUnsetCommands( $aliases, $scope, $list ) {
    $cmds = [];
    foreach ( $list as $alias => $_) {
        $cmds[] = 'git config ' . $scope . ' --unset alias.' . $alias;
    }

    return $cmds;
}


function gitaliases( $test, $configFile = false ) {
    // workflow: cleanup (optional) -> drop/remove -> add aliases

    // using a json5 config for aliases:
    //
    // shared (maintainer config as default):
    //      mk_git_aliases.config-shared.json5
    //
    // your own, if you dont want the setup from the maintainer:
    // custom config (if this file exists, this is your own config to setup the script):
    //      mk_git_aliases.config-custom.json5
    //

    $json5 = file_get_contents( $configFile );
    $aliases = json5_decode( $json5, true );

    $execlist = array();
    foreach ( $aliases as $job => $list ) {

        foreach( $list as  $way => $commands ) {
            $wayRaw = $way;
            $user = getenv('USER') ?: getenv('LOGNAME') ?: getenv('USERNAME') ?: get_current_user();
            if ( $way === 'system' && $user !== 'root' ) {
                // echo 'skip, not root' . PHP_EOL;
                continue;
            }

            $way = '--' . $way;

            switch ( $job )
            {
                case 'cleanup':
                    if ( $commands === true ) {
                        foreach ( $aliases['add'][$wayRaw] as $alias => &$cmd ) {
                            $execlist[] = 'git config ' . $way . ' --unset alias.' . $alias;
                        }
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
            $data = null;
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


// order: FIFO (first match will be used)
$possibleFiles = array(
    __DIR__ . '/mk_git_aliases.config-custom.json5',
    __DIR__ . '/mk_git_aliases.config-shared.json5',
);

$configFileToUse = null;
foreach ( $possibleFiles as $configFile ) {
    if ( file_exists( $configFile ) ) {
        $configFileToUse = $configFile;

        break;
    }
}

if ( ! $configFileToUse ) {
    echo 'No config found' . PHP_EOL;
    exit( 1 );
}


$test = true;
if ( @$_SERVER['argv'][1] === 'run' ) {
    $test = false;
} else {
    echo '# To execute commands run: "php ' . basename( __FILE__ ) . ' run"' . PHP_EOL;
}

gitaliases( $test, $configFileToUse );
