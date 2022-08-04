read -n1 -p "Do you want to download gazebo models? [y/n]" input
echo ""
if [ $input = "y" ];then
    echo -e "\e[32mNow dowloading gazebo models....\e[0m"
    git clone https://github.com/osrf/gazebo_models ~/.gazebo/models
fi

read -n1 -p "Do you want to install rosdepc and update rosdep database?(Fro Chinese mainland user only.) [y/n]" input
echo ""
if [ $input = "y" ];then
    echo -e "\e[32mNow update rosdep database using rosdepc....\e[0m"
    sudo pip install rosdepc
    sudo rosdepc init
    rosdepc update
fi

echo -e "\e[32mNow download limo_ros2 package....\e[0m"
git clone https://github.com/agilexrobotics/limo_ros2.git src
echo -e "\e[32mNow install limo_ros2 dependence....\e[0m"
( rosdepc install --from-paths src --ignore-src -r -y ) || ( rosdep install --from-paths src --ignore-src -r -y )
source /opt/ros/foxy/setup.bash