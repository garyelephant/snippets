#!/bin/bash

azkaban_url="http://172.17.11.199:8443/executor"

project=mercuryv2_union_settlement_sync

if [ $# != 4 ]; then
    echo "please specify <flow_name> <start_day:20181001> <end_day:20181101> <sleep_seconds>"
    exit -1
fi

flow=$1
start_day_str=$2
end_day_str=$3
sleep_seconds=$4

start_day=$(date -d "$start_day_str" +%s)
end_day=$(date -d "$end_day_str" +%s)

t=$start_day
while [ $t -lt $end_day ] ; do
    let "t_plus_one_day = $t + 86400"
    t_str=$(date -d @$t +%Y%m%d)
    t_plus_one_day_str=$(date -d @$t_plus_one_day +%Y%m%d)

    echo "[INFO] going to execute flow: project:mercuryv2_union_settlement_sync, flow: $flow, day range: [$t_str, $t_plus_one_day_str), day range unix_timestamp: [$t, $t_plus_one_day)"
    curl --get -d 'session.id=33a52bc8-1ef3-45ed-ae43-195887ea4697' -d 'ajax=executeFlow' -d 'project=mercuryv2_union_settlement_sync' -d "flow=$flow" -d "flowOverride[start_day]=$t" -d "flowOverride[end_day]=$t_plus_one_day" $azkaban_url

    if [ $? != 0 ]; then
        echo "[ERROR] encountered error, quit "
        break
    fi

    echo "[INFO] finished!"
    t=$t_plus_one_day
    sleep $sleep_seconds
done


echo "[INFO] finished processing all!"
