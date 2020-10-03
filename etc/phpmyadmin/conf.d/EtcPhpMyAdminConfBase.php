<?php

// EtcPhpmyadminConfbase.php file

if ( !class_exists('EtcPhpmyadminConfbase') ) {

/**
 * Rule: NNNN-hostname.php filename
 * id: 1000 - 9999, eg: 1001
 * hostname e.g: my.domain.de
 * filename: 1001-my.domain.de.php
 *                            ^^^^ - extension
 *                ^^^^^^^^^^^^     - domain/ hostname
 *               ^                 - split
 *           ^^^^----------------- - id: (4 numbers) 1000 - 9999
 */
class EtcPhpMyAdminConfBase 
{
    private $_currentFile = '';
    private static $_rec = array();
    
    /**
     * Init the object
     */
    public function __construct($currentFile) {
        $this->_currentFile = basename($currentFile);
    }
    
    public function getId() {
        // rule: first 4 strings of the filename
        $rec = substr( $this->_currentFile, 0, 4 );
        
        if ( isset(self::$_rec[$rec]) ) {
            $mesg = sprintf(
                'PhpMyAdmin config: ID "%1$s" in conf.d/ already set/exists in file: "%2$s"',
                $rec,
                self::$_rec[$rec]
            );
            throw new Exception( $mesg );
        } else {
            self::$_rec[$rec] = $this->_currentFile;
        }
        return $rec;
    }
    
    public function getHostname() {
        // rule (id1000-9999)-hostname.php   
        return substr($this->_currentFile, 5, -4);
    }
}

} // end if class exists
