#!/usr/bin/env node

'use strict';

/**
 * Git alias generator - node version
 *
 * @autor Florian Blasel
 *
 * Executes shell commands to update/remove or init git aliases
 *
 * Check: mk_git_aliases.README.md for more
 */

const FS = require( 'node:fs' );
const JSON5 = require( 'json5' );
const OS = require( "node:os" );
const PROCESS = require( 'node:process' );

function gitaliases( test )
{
    // let file = './mk_git_aliases.json.tmp';
    let file = __dirname + '/mk_git_aliases.shared-config.json5';
    let jsontxt = FS.readFileSync( file, 'utf8' );
    const jsonstring = JSON5.parse( jsontxt );
    let user = OS.userInfo().username;
    const execlist = [];

    Object.entries( jsonstring ).forEach( aliasConfig => {
        const [job, list] = aliasConfig;

        Object.entries( jsonstring[ job ] ).forEach( wayList => {
            let [way, commands] = wayList;
            let wayRaw = way;

            if ( way === 'system' && user !== 'root' ) {
                // console.log( 'skip system settings: you are not root for this task' );
                return;
            }

            if ( way === 'local' ) {
                way = '--local';
            } else {
                way = '--' + way;
            }

            switch ( job ) {
                case 'cleanup':
                    if ( commands === true ) {
                        // console.log(  jsonstring[ 'add' ][wayRaw] );
                        Object.entries( jsonstring[ 'add' ][ wayRaw ] ).forEach( aliasList => {
                            let [alias, cmd] = aliasList;
                            execlist.push( `git config ${way} --unset alias.${alias}` );
                        } );
                    }
                    break;

                case 'drop':
                    Object.entries( commands ).forEach( aliasList => {
                        let [alias, cmd] = aliasList;
                        if ( cmd === true ) {
                            execlist.push( `git config ${way} --unset alias.${alias}` );
                        }
                    } );
                    break;

                case 'add':
                    Object.entries( commands ).forEach( aliasList => {
                        let [alias, cmd] = aliasList;
                        execlist.push( `git config ${way} alias.${alias} "${cmd}"` );
                    } );
                    break;

                default:
                    console.log( job, ' not implemented' );
            }
        } );
    } );

    const { exec } = require( "child_process" );
    const execSync = require( 'child_process' ).execSync;
    let code = null;
    Object.values( execlist ).forEach( cmdline => {
        if ( test !== true ) {
            try {
                execSync( cmdline );
            }
            catch ( err ) {
                if ( err.status > 5 ) {
                    console.log( err );
                }
            }
        } else {
            console.log( cmdline );
        }
    } );
}

var test = true;
if ( PROCESS.argv[2] === "run" ) {
    test = false;
}

gitaliases( test );
