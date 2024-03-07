#!/usr/bin/env node

'use strict';

/**
 * Git alias generator - node version
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
 * Requires: node packages (`apt install node node-json5` ) or get nvm to have
 * node in user space: https://github.com/nvm-sh/nvm BUT: you may need json5
 * package local (here in ./).
 */

const FS = require( 'node:fs' );
const JSON5 = require( 'json5' );
const OS = require("node:os");
const PROCESS = require('node:process');

function gitaliases( test )
{
    let file = './mk_git_aliases.json.tmp';
    let jsontxt = FS.readFileSync( file, 'utf8' );
    const jsonstring = JSON5.parse( jsontxt );
    let user = OS.userInfo().username;
    const execlist = [];

    Object.entries( jsonstring ).forEach( aliasConfig => {
        const [ job, list ] = aliasConfig;

        Object.entries( jsonstring[ job ] ).forEach( wayList => {
            let [ way, commands ] = wayList;
            let wayRaw = way;

            if ( way == 'system' && user != 'root' ) {
                // console.log( 'skip system settings: you are not root for this task' );
                return;
            }

            if ( way == 'local' ) {
                way = '--local';
            } else {
                way = '--' + way;
            }

            switch ( job ) {
                case 'cleanup':
                    if ( commands === true ) {
                        // console.log(  jsonstring[ 'add' ][wayRaw] );
                        Object.entries( jsonstring[ 'add' ][wayRaw] ).forEach( aliasList => {
                            let [ alias, cmd ] = aliasList;
                            execlist.push( `git config ${way} --unset alias.${alias}`);
                        });
                    }
                    break;

                case 'drop':
                    Object.entries( commands ).forEach( aliasList => {
                        let [ alias, cmd ] = aliasList;
                        if ( cmd === true ) {
                            execlist.push( `git config ${way} --unset alias.${alias}`);
                        }
                    });
                    break;

                case 'add':
                    Object.entries( commands ).forEach( aliasList => {
                        let [ alias, cmd ] = aliasList
                        execlist.push( `git config ${way} alias.${alias} "${cmd}"`);
                    });
                break;

                default:
                    console.log(job, ' not implemented' );
            }
        } );
    } );

    const { exec } = require("child_process");
    const execSync = require('child_process').execSync;
    let code = null;
    Object.values( execlist ).forEach( cmdline => {
        if ( test !== true ) {
            try {
                execSync( cmdline );
            } catch ( err ) {
                if ( err.status > 5 ) {
                    console.log( err );
                }
            }
        } else {
            console.log( cmdline );
        }
    });
}

var test = true;
if ( PROCESS.argv[2] === "run" ) {
    test = false;
}

gitaliases( test );
