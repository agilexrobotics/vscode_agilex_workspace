# ROS2 开发模板使用



本文主要讲解如何在 Jetson 平台上进行 ROS2 进行开发。

> 本文所述开发方式同样适用于任意开发平台，只是相对来讲要 Jetson 直接使用 ubuntu 20.04 或 ROS2 普通的方法相对困难

鉴于 Jetson 官方暂无 `Ubuntu 20.04` 镜像，本文讲解如何使用 `Docker` + `VS Code` **快速部署** ROS2 开发环境

**Why Docker？**

- 相对于虚拟机 Docker 使用了 LXC 及 UnionFS 技术，极大的减轻了镜像体积和资源需求
- 基于 Docker File 文件构建镜像 或通过 Docker Hub 分享，可以让开发者快速部署**完全一样**的开发环境。
- Docker 开发者众多，**很多我们需要的开发环境早已有人分享**

**Why VS Code?**

诚然大家可能更加喜欢 `vim` `emacs` 等编辑软件。但经过笔者个人折腾，相对来讲 VS Code 的使用门槛更低，插件丰富且安装方便更有 task 等高级功能支持，可以更加简单的获得高效开发体验。

**开始使用**

1. 首先确保我们本地电脑已经安装 VS Code 并且安装了如下插件：

![image-20220804164515432](images/1.png)

成功安装后，在 VS Code 界面左下角会有如下图标：

![image-20220804164730402](images/2.png)

确保 Jetson 和 本地电脑 处于**同一局域网**之中，找到 Jetson 的 ip 地址：

![image-20220804165403542](images/3.png)

> 注意：推荐通过将 IP 地址与 MAC 地址绑定 或其他任何方式让 远程计算机 IP 地址不变。
>
> 如果 IP 在电脑重启后发生改变，则需要修改下文中的 `HostName` 字段的值

点击 左下角的小图标 ![image-20220804164730402](images/2.png)

在弹出的对话框中选择 `Connect to Host`

![image-20220804173336196](images/4.png)

选择 `configure SSH Hosts`

![image-20220804173732362](images/5.png)

任选一个文件打开：

![image-20220804173822682](images/6.png)

在打开的文件中追加如下内容

```
Host limo
    HostName 192.168.3.35
    User agilex
    ForwardX11 yes
    ForwardX11Trusted yes
```

> 参数含义：
>
> Host 别名，可以任起
>
> HostName 远程计算机 IP 地址
>
> User 登录使用的用户名
>
> ForwardX11 传递 X11
>
> ForwardX11Trusted 信任 X11

保存该文件即可，但此时我们登陆时仍需要输入密码，可以通过以下方法**免密登录**：

**免密登录配置（可选）**

首先生成密钥（Windows 用户通过 git bash 使用该指令）

```shell
$ cd ~/.ssh/
$ ssh-keygen
```

在提示信息中输入自定义密钥文件名称：

![image-20220804174446694](images/7.png)

> 注意：如果此使用默认名称可能导致已存在密钥被覆盖！

之后一路点击回车，可以看到密钥生成成功：

![image-20220804174622319](images/8.png)

接下来上传密钥文件到远程计算机：

```shell
$ ssh-copy-id -i limo_rsa.pub agilex@192.168.3.35
```

> limo_rsa.pub 为刚刚生成的公钥， agilex 为远程计算机用户名 192.168.3.35 为远程计算机地址

之后输入 远程计算机密码 即可成功上传公钥。

最后回到我们刚刚编辑的配置文件，在最后一行追加

```
IdentityFile ~/.ssh/limo_rsa
```

之后保存：

![image-20220804175355859](images/9.png)

**建立连接**

点击 ![image-20220804164730402](images/2.png)，在打开的选项中 选择 ``Connect to Host ``

在弹出的菜单中选择我们刚刚配置的选项：

![image-20220804175612644](images/10.png)

在弹出的窗口中输入密码（已配置免密登录则不用）等待 VS Code 初始化远程环境，做下角图片变为如图所示内容表示连接成功：

![image-20220804180053978](images/11.png)

**配置远程开发环境**

本节使用松灵 LIMO 机器人为例，搭载 Jetson Nano 主机。

在上节中打开的远程连接界面使用快捷键 `` Ctrl + ` ``（按键 “`” 在 ESC 键下方）打开命令行窗口

![image-20220804182824363](images/12.png)



下载 limo-ros2-nvidia 模板到 Jetson （即 车载电脑）之上：

```shell
$ git clone -b limo_ros2-nvidia https://github.com/agilexrobotics/vscode_agilex_workspace.git
```

完成后下载 limo_ros2 包

```shell
$ cd vscode_agilex_workspace
$ git clone https://github.com/agilexrobotics/limo_ros2.git src
```

完成后点击 VSCode 菜单栏的 ``文件（File）---> 打开文件夹（Open folder)``（快捷键 ``Ctrl+K+O``）打开 ``vscode_agilex_workspace``

![image-20220804184150773](images/13.png)

输入密码（配置免密登录后不需要）后 `Remote container` 插件会弹出提示：

![image-20220804184341600](images/14.png)

点击 `Reopen in Container` 

**如果没有弹出**则点击左下角 ![image-20220804180053978](images/11.png),在弹出的窗口中点击 `Remote container`

![image-20220804184647581](images/15.png)

之后会 VSCode 会为我们自动配置开发环境。当文件管理器重新出现目录并且左下角图标变为：

![image-20220804184913511](images/16.png)

即代表容器启动成功，现在的所有操作都在容器中进行，可以愉快的进行开发。



**访问图形界面**

在 ROS2 开发过程中我们难免要使用  rviz2 等图形界面，经过笔者测试远程连接使用 X11 进行窗口绘制可能出现各种由 Nvidia 显卡导致的驱动问题导致无法成功绘制窗口，且即使成功绘制也会存在帧率过低的问题。

对此我们可以利用 ROS2 的分布式网络特性，在本机主机接受远程电脑消息并通过 rviz2 访问数据

在我们本地计算机上（非 Jetson）

