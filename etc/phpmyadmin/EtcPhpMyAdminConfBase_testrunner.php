<?php

// test for duplicate id's

foreach (glob( __DIR__ . '/conf.d/*.php') as $filename)
{
    if ($filename == __FILE__ ) {
        continue;
    }
    include($filename);
}
