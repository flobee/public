#!/usr/bin/env php
<?php
/**
 * Munin Plugin for the VDR 
 * Graph: Up = green, Down = red
 *
 * Version 1.0
 *  - Release
 */

error_reporting(-1);
ini_set('memory_limit', '8M');
 
$arg1 = @$_SERVER['argv'][1];

$time = $_SERVER['REQUEST_TIME'];

$last24h = $time - 86400; 



switch($arg1) 
{
    case 'autoconf':
        echo 'yes' . PHP_EOL;
        exit(0);
        break;
    
    case 'config':
        echo 'graph_title VDR sleep/wake time' . PHP_EOL;
        echo 'graph_args -l 0 --base 1000' . PHP_EOL;
        echo 'graph_vlabel VDR Uptime (+) / VDR Downtime (-) in min.' . PHP_EOL;
        echo 'graph_category vdr' . PHP_EOL;
        //echo 'graph_width 500' . PHP_EOL;
        //echo 'graph_height 250' . PHP_EOL;
        
        echo 'vdrNumTimers.label Num timers today' . PHP_EOL;
        echo 'vdrNumTimers.type COUNTER' . PHP_EOL;
        echo 'vdrNumTimers.colour 00FF00' . PHP_EOL;
        echo 'vdrNumTimers.max 10' . PHP_EOL;
        echo 'vdrNumTimers.min 0' . PHP_EOL;
        
        exit(0);
        break;
}



//needs a cache!
$numTimers=exec('svdrpsend -d localhost lstt | cut -d \':\' -f-8 | grep `date +\'%Y-%m-%d\'` | wc -l | tr -d \'\r\n\'');
echo "vdrNumTimers.value $numTimers\n";





