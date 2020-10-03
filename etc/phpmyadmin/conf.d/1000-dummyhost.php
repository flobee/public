<?php

// based on debian default setup for mariadb/mysql

// 'global' probably does not work, so set all required credentials manually!
global $dbuser, $dbpass, $dbport, $dbserver, $dbname;


/**
 * init the helper object to enable this host config
 */

require_once __DIR__ . '/EtcPhpMyAdminConfBase.php';
/** @var EtcPhpMyAdminConfBase $etcPhpmyadminConfbase The conf base object */
$etcPhpmyadminConfbase = new EtcPhpMyAdminConfBase( __FILE__ );

/* debug, tests: 
print_r( $etcPhpmyadminConfbase );
echo PHP_EOL;
print_r( $etcPhpmyadminConfbase->getId() );
echo PHP_EOL;
print_r( $etcPhpmyadminConfbase->gethostname() );
echo PHP_EOL;
*/


$i = $etcPhpmyadminConfbase->getId();

/**
 * copy from config.inc.php and to be enabled for this file/hostname/id:
 */

/* Authentication type */
$cfg['Servers'][$i]['auth_type'] = 'cookie';
/* Server parameters */
$cfg['Servers'][$i]['host'] = $etcPhpmyadminConfbase->gethostname(); // default: $dbserver|$dbhost
$cfg['Servers'][$i]['port'] = '3306'; // default: $dbport, default port = 3306
$cfg['Servers'][$i]['connect_type'] = 'tcp'; // default: tcp
$cfg['Servers'][$i]['compress'] = false; // default: false
/* Uncomment the following to enable logging in to passwordless accounts,
 * after taking note of the associated security risks. */
$cfg['Servers'][$i]['AllowNoPassword'] = false; // default: false

/**
 * phpMyAdmin configuration storage settings.
 */

/* User used to manipulate with storage */
// $cfg['Servers'][$i]['controlhost'] = ''; // default: the hostname
// $cfg['Servers'][$i]['controlport'] = ''; // default: the host's port
$cfg['Servers'][$i]['controluser'] = $dbuser; // default: $dbuser
$cfg['Servers'][$i]['controlpass'] = $dbpass; // default: $dbpass

/* Storage database and tables */
$cfg['Servers'][$i]['pmadb'] = 'phpmyadmin'; // default: 'phpmyadmin' $dbname
$cfg['Servers'][$i]['bookmarktable'] = 'pma__bookmark';
$cfg['Servers'][$i]['relation'] = 'pma__relation';
$cfg['Servers'][$i]['table_info'] = 'pma__table_info';
$cfg['Servers'][$i]['table_coords'] = 'pma__table_coords';
$cfg['Servers'][$i]['pdf_pages'] = 'pma__pdf_pages';
$cfg['Servers'][$i]['column_info'] = 'pma__column_info';
$cfg['Servers'][$i]['history'] = 'pma__history';
$cfg['Servers'][$i]['table_uiprefs'] = 'pma__table_uiprefs';
$cfg['Servers'][$i]['tracking'] = 'pma__tracking';
$cfg['Servers'][$i]['userconfig'] = 'pma__userconfig';
$cfg['Servers'][$i]['recent'] = 'pma__recent';
$cfg['Servers'][$i]['favorite'] = 'pma__favorite';
$cfg['Servers'][$i]['users'] = 'pma__users';
$cfg['Servers'][$i]['usergroups'] = 'pma__usergroups';
$cfg['Servers'][$i]['navigationhiding'] = 'pma__navigationhiding';
$cfg['Servers'][$i]['savedsearches'] = 'pma__savedsearches';
$cfg['Servers'][$i]['central_columns'] = 'pma__central_columns';
$cfg['Servers'][$i]['designer_settings'] = 'pma__designer_settings';
$cfg['Servers'][$i]['export_templates'] = 'pma__export_templates';
/* Contrib / Swekey authentication */
// $cfg['Servers'][$i]['auth_swekey_config'] = '/etc/swekey-pma.conf';

