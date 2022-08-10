
echo -e "\e[32mNow switch your package source to China mirror source\e[0m"
sudo sed -i "s/ports.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list
sudo sed -i "s/archive.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list
sudo sed -i "s/packages.ros.org/repo.huaweicloud.com/g" /etc/apt/sources.list.d/ros-latest.list
sudo apt  update

echo -e "\e[32mNow switch your pip package source to China mirror source\e[0m"
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

echo -e "\e[32mNow update rosdep database using rosdepc....\e[0m"
sudo pip install rosdepc
sudo rosdepc init
rosdepc update

echo -e "\e[32mNow update ros.repos ....\e[0m"
for file in "setup.sh" "src/ros.repos"
do
        a=$(awk "/ghproxy.com/{print}" $file)
        if [ -n "$a" ]
        then
                echo "$file already update."
        else
                sed -i "s#https://github.com#https://ghproxy.com/https://github.com#g" $file
        fi
done

a=$(awk "/^rosdepc/{print}" setup.sh)
if [ -n "$a" ]
then
        echo "rosdepc already update."
else
        sed -i "s/rosdep/rosdepc/g" setup.sh
fi