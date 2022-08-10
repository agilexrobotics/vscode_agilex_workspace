set -e

sed -i "s/ports.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list
sed -i "s/archive.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list
sed -i "s/packages.ros.org/repo.huaweicloud.com/g" /etc/apt/sources.list.d/ros-latest.list

for file in "/tmp/library-scripts/common-debian.sh"
do
        a=$(awk "/ghproxy.com/{print}" $file)
        if [ -n "$a" ]
        then
                echo "$file already update."
        else
                sed -i "s#https://github.com#https://ghproxy.com/https://github.com#g" $file
        fi
done