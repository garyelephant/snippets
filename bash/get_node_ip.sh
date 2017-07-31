## -- note: only for centos6, centos7

# detect centos version
centos_version=6
is_centos_v7=`cat /etc/redhat-release|grep 7`
is_centos_v6=`cat /etc/redhat-release|grep 6`

ifconfig_command=/usr/sbin/ifconfig
if [ ! -f "$ifconfig_command" ]; then
    ifconfig_command=/sbin/ifconfig
fi

NODE_IP=invalid_ip

if [[ ! -z $is_centos_v6 ]]; then
    centos_version=6
    NODE_IP=$($ifconfig_command |grep "inet" | grep -v "127.0.0.1" | awk '{print $2}' | awk -F ':' '{print $2}');

elif [[ ! -z $is_centos_v7 ]]; then
    centos_version=7
    NODE_IP=$($ifconfig_command |grep "inet" | grep -v "127.0.0.1" | awk '{print $2}');
fi

echo "$NODE_IP"
