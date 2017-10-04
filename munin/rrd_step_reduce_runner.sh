#!/bin/dash

# @see
# https://www.justinsilver.com/technology/linux/change-interval-munin-existing-rrd-data/
# http://www.sekuda.com/changing_munin_2_to_collect_data_every_minute

newInterval=$1;
oldInterval=5;
PATH_RRD='/var/lib/munin';

if [ "$newInterval" = "" ]; then
    echo 'missing interval in minutes';
    exit 1;
else
    echo "Try to set new interval of $newInterval ...";
fi



find $PATH_RRD -type f -iname "*.rrd" -print0 | while IFS= read -r -d $'\0' filename; do
	echo $filename
	rrdtool dump $filename > temp.$oldInterval.xml
	./rrd_step_reduce.py temp.$oldInterval.xml $oldInterval > temp.$newInterval.xml
	rm $filename
	rrdtool restore temp.$newInterval.xml $filename
done
