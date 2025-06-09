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

const
    FS = require( 'node:fs' ),
    PATH = require('node:path'),
    JSON5 = require( 'json5' ),
    OS = require( "node:os" ),
    PROCESS = require( 'node:process' ),
    { execSync } = require('child_process');


/**
 * Reads and parses the json config file.
 *
 * @param {string} filePath - Path to the JSON5 configuration file.
 * @returns {object} Parsed configuration object.
 */
function readConfigFile( filePath ) {
    try {
        const content = FS.readFileSync( filePath, 'utf8' );
        return JSON5.parse( content );
    } catch ( error ) {
        console.error( `Error reading or parsing the config file: ${error.message}` );
        PROCESS.exit( 1 );
    }
}

/**
 * Creates a Git command string.
 *
 * @param {string} action - The action to perform (e.g., --unset, --add).
 * @param {string} scope - The scope of the command (e.g., --local, --global).
 * @param {string} alias - The alias name.
 * @param {string} [command] - The command to associate with the alias (optional).
 * @returns {string} The constructed Git command.
 */
function createGitCommand( action, scope, alias, command = '' ) {
    if (action === '--add' && command) {
        // Escape any double quotes in the command
        const safeCmd = command.replace(/"/g, '\\"');
        return `git config ${scope} ${action} alias.${alias} "${safeCmd}"`.trim();
    }
    return `git config ${scope} ${action} alias.${alias}`.trim();
}

/**
 * Generates and executes Git alias commands based on the configuration.
 *
 * @param {boolean} test - If true, commands are printed instead of executed.
 */
function gitaliases( test ) {
    const possibleFiles = [
        PATH.join( __dirname, 'mk_git_aliases.config-custom.json5' ),
        PATH.join( __dirname, 'mk_git_aliases.config-shared.json5' )
    ];

    let configFileToUse = null;
    for ( const file of possibleFiles ) {
        if (FS.existsSync(file)) {
            configFileToUse = file;
            break;
        }
    }

    if ( !configFileToUse ) {
        console.error('No config found');
        process.exit(1);
    }

    const config = readConfigFile( configFileToUse );
    const user = OS.userInfo().username;
    const execlist = [];

    Object.entries( config ).forEach( ( [job, jobConfig] ) => {
        Object.entries( jobConfig ).forEach( ( [scope, commands] ) => {
            if ( scope === 'system' && user !== 'root' ) {
                console.warn( 'Skipping system settings: you are not root for this task' );
                return;
            }

            const gitScope = scope === 'local' ? '--local' : `--${scope}`;

            switch ( job ) {
                case 'cleanup':
                    if ( commands === true ) {
                        Object.entries( config['add'][scope] ).forEach( ( [alias] ) => {
                            execlist.push( createGitCommand( '--unset', gitScope, alias ) );
                        });
                    }
                    break;

                case 'drop':
                    Object.entries( commands ).forEach( ( [alias, cmd] ) => {
                        if (cmd === true) {
                            execlist.push( createGitCommand( '--unset', gitScope, alias ) );
                        }
                    });
                    break;

                case 'add':
                    Object.entries( commands ).forEach( ( [alias, cmd] ) => {
                        if ( typeof cmd === 'string' && cmd.trim() !== '' ) {
                            execlist.push( createGitCommand( '--add', gitScope, alias, cmd) );
                        }
                    });
                    break;

                default:
                    console.warn( `Unknown job type: ${job}` );
            }
        });
    });

    execlist.forEach( ( cmdline ) => {
        if ( !test ) {
            try {
                // console.log(`Executing: ${cmdline}`);
                execSync( cmdline, { stdio: 'inherit' } );
            } catch (err) {
                console.error( `Error executing command "${cmdline}": ${err.message}` );
            }
        } else {
            console.log( cmdline );
        }
    });
}

const test = PROCESS.argv[2] !== 'run';

gitaliases( test );
