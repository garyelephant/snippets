#!/bin/bash

## execute flow
## auto retry if skipping execution
##

azkaban_url="http://127.0.0.1:8443" # TODO: configure this
azkaban_user="myuser"  # TODO: configure this
azkaban_password="mypassword"  # TODO: configure this

project=myproject # TODO: configure this

if [ $# != 4 ]; then
    echo "please specify <flow_name> <start_day:20181001> <end_day:20181101> <sleep_seconds>"
    exit -1
fi

string_trim() {
    echo $1 | awk '{$1=$1;print}'
}

get_sessionid() {
    user=$1
    password=$2

    sid=$(curl -k -X POST $azkaban_url --data "action=login&username=$user&password=$password" 2>/dev/null | grep "session" | awk -F ':' '{print $2}' | awk -F '"' '{print $2}')
    echo $sid
}

sessionid=$(get_sessionid $azkaban_user $azkaban_password)

echo "[INFO] azakban user: $azkaban_user, sessionid: $sessionid"

flow=$1
start_day_str=$2
end_day_str=$3
sleep_seconds=$4

start_day=$(date -d "$start_day_str" +%s)
end_day=$(date -d "$end_day_str" +%s)


t=$start_day
while [ $t -lt $end_day ] ; do
    let "t_plus_one_day = $t + 86400"
    t_str=$(date -d @$t +%Y-%m-%d)
    t_plus_one_day_str=$(date -d @$t_plus_one_day +%Y-%m-%d)

    echo "[INFO] going to execute flow: project:$project, flow: $flow, day range: [$t_str, $t_plus_one_day_str), day range unix_timestamp: [$t, $t_plus_one_day)"

    arg_start_day=$t_str
    arg_end_day=$t_plus_one_day_str
    arg_conf_name="$flow.conf"
    arg_app_name="$flow-$t_str-$t_plus_one_day_str"

    echo "arg[start_day] = $arg_start_day"
    echo "arg[end_day] = $arg_end_day"
    echo "arg[conf_name] = $arg_conf_name"
    echo "arg[app_name] = $arg_app_name"

    response=$(curl --get -d "session.id=$sessionid" -d "ajax=executeFlow" -d "project=$project" -d "flow=$flow" \
        -d "flowOverride[start_day]=$arg_start_day" -d "flowOverride[end_day]=$arg_end_day" \
        -d "flowOverride[conf_name]=$arg_conf_name" -d "flowOverride[app_name]=$arg_app_name" \
        "$azkaban_url/executor" 2>/dev/null)

    if [ $? != 0 ]; then
        echo "[ERROR] encountered error, quit "
        break
    fi

    error=$(echo $response | grep "Error submitting" | grep "Skipping execution")
    error=$(string_trim "$error")
    if [ -z "$error" ]; then
        ## error is empty
        echo "[INFO] finished!"
        t=$t_plus_one_day

    else
        ## Error submitting flow <XXX>. Flow <XXX> is already running. Skipping execution.",
        echo "[WARN] failed to submit due to skipping execution ! Retry later."
    fi

    sleep $sleep_seconds
done


echo "[INFO] finished processing all!"
