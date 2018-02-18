#!/usr/bin/env php
<?php
/**
 * Munin Plugin for the VDR project
 * seperated scripts of the upcomming vdr-tools project @ github.com/flobee
 *
 * Version 1.0
 *  - Release
 */

error_reporting(-1);
ini_set('memory_limit', '8M');


$config = require_once __FILE__ .'.cfg.php';

/**
 * A file (csv) containing vdr unix timestamps: start;stop
 */
$statsfile = $config['statsfile'];


$arg1 = @$_SERVER['argv'][1];

$time = $_SERVER['REQUEST_TIME'];

$last24h = $time - 86400; 
$last36h = $time - 86400 - 43200; 


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

        echo 'vdruptime.label Uptime (now)' . PHP_EOL;
        echo 'vdruptime.colour 00FF00' . PHP_EOL;
        echo 'vdruptime.type GAUGE' . PHP_EOL;

        echo 'vdrdowntime.label Downtime (now)' . PHP_EOL;
        echo 'vdrdowntime.colour FF0000' . PHP_EOL;
        echo 'vdrdowntime.type GAUGE' . PHP_EOL;

        echo 'vdravguptimelasttwfourh.label Uptime average last 36 hours' . PHP_EOL;
        echo 'vdravguptimelasttwfourh.colour 0000FF' . PHP_EOL;
        echo 'vdravguptimelasttwfourh.type GAUGE' . PHP_EOL;
        
        echo 'vdravguptimetotal.label Uptime average (all times)' . PHP_EOL;
        echo 'vdravguptimetotal.colour FFBB00' . PHP_EOL;
        echo 'vdravguptimetotal.type GAUGE' . PHP_EOL;

        exit(0);
        break;
}


$uptime = $downtime = $vdruptime = $vdrdowntime = 0;

$stats = file($statsfile, FILE_IGNORE_NEW_LINES );

$records = array(
    'durations' => array(), 
    'durations_sum' => 0, 
    'duration_average' => 0, 
    'durations_lasttwfourh' => array(),
    'durations_lasttwfourh_sum' => 0
);

$i = $j = 0;
//while(list(,$line) = each($stats) )
foreach ( $stats as $line ) {
    $rec = explode(';', $line);
    
    if (empty($rec[1])) {
        $records[$j]['start'] = trim($rec[0]);
        $uptime = $records[$j]['start'];
        $downtime = 0;
    } 
    else {
        if (!isset($records[$j]['start'])) {
            $records[$j]['start'] = trim($rec[0]);
        }
        $records[$j]['stop'] = substr(trim($rec[1]), 0,10);
        $records[$j]['duration'] = $records[$j]['stop'] - $records[$j]['start'];
        $records['durations'][] = $records[$j]['duration'];
        $records['durations_sum'] += $records[$j]['duration'];
        $uptime = 0;
        $downtime = $records[$j]['stop'];

        // uptime last 24h/36h records
        if ($records[$j]['start'] >=  $last36h) // $last24h 
        {
            $records['durations_lasttwfourh'][] = $records[$j]['duration'];
            $records['durations_lasttwfourh_sum'] += $records[$j]['duration'];
        }
        $j++;
    }
    $i++;
}
if (!isset($records[$j]['stop']) && isset($records[$j]['start'])) { 
    $records[$j]['duration'] = time() - $records[$j]['start'];
    $records['durations_lasttwfourh'][] = $records[$j]['duration'];
    $records['durations_lasttwfourh_sum'] += $records[$j]['duration'];
}

// generate output in minutes
$uptimeAverageTotal = intval($records['durations_sum'] / count($records['durations']) / 60);
$uptimeAverageToday = intval($records['durations_lasttwfourh_sum'] / count($records['durations_lasttwfourh']) / 60 );

if ($downtime) {
    $vdrdowntime = intval( ($time - $downtime) / 60);
} else {
    $vdruptime = intval(($time - $uptime) / 60);
}

echo "vdruptime.value $vdruptime\n"; 
echo "vdrdowntime.value $vdrdowntime\n";
echo "vdravguptimelasttwfourh.value $uptimeAverageToday\n";
echo "vdravguptimetotal.value $uptimeAverageTotal\n";
