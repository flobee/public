<?php

$o = new Mumsys_Service_Ssh_Config_Generator_Default();
$o->run();


class Mumsys_Service_Ssh_Config_Generator_Default
{
    /**
     * Location to the target ssh config file to save the content to
     * @var string
     */
    private $_sshConfFile;

    /**
     * Location to the path where configs exists to create the ssh config
     * @var string
     */
    private $_confsPath;


    /**
     * Initialize the object
     */
    public function __construct()
    {
        $this->_sshConfFile = __DIR__ . '/config-gen'; // '~/.ssh/config';
        $this->_confsPath = __DIR__ . '/conffiles/';
    }


    /**
     * Sets the location to the path where config files exists to create the
     * ssh config file.
     *
     * @param string $path
     */
    public function setConfigPath( string $path )
    {
        $this->_confsPath = $path;
    }


    /**
     * Sets the location to the ssh config file to write to.
     *
     * @param string $file Location to the ssh config file
     */
    public function setSshConfigFile( string $file )
    {
        $this->_sshConfFile = $file;
    }


    /**
     * Generates the ssh config file.
     */
    public function run()
    {
        $list = scandir( $this->_confsPath );
        natcasesort($list);
        $string = '';
        foreach ( $list as $file ) {
            if ( $file[0] === '.' ) {
                continue;
            }

            $config = require_once $this->_confsPath . '/' . $file;
            $string .= $this->_buildString( $config );
        }

        file_put_contents( $this->_sshConfFile, $string );
    }


    /**
     * Returns the config content as string.
     *
     * @param array $config List of key/value pairs representinga line of a ssh
     * config
     *
     * @return string Config string to be added to the target
     */
    private function _buildString( $config )
    {
        $string = '';
        foreach ( $config as $key => $value ) {
            $numeric = is_numeric( $key );
            if ( $numeric ) {
                $string .= $value . "\n";
            } else {
                $string .= $key . ' ' . $value . "\n";
            }
        }

        return $string . "\n";
    }

}
