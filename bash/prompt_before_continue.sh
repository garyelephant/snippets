
function delete_user {
    user_id=$1
    ## do something to delete user
}

# main():
if [ $# != 3 ]; then
    echo "wrong arguments, please specify <use_id>"
    echo "example : ./delete_user.sh 867"
    exit -1
fi

user_id=$1

echo "准备删除用户，ID: $1"

# 等待用户输入后继续
while :
do
    read -p "是否确认(yes|no):" choice
    [ -z $choice ] && continue

    [[ "$choice" == "no" ]] && echo "不操作，直接推出!" && exit 0
    [[ "$choice" == "yes" ]] && break
done

echo "开始删除..."


delete_user $user_id
