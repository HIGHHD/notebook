### 安装发行版需要注意的问题

```
让创建user时，直接回车后关闭，不要创建用户，否则在shutdown后会导致无法启动
```

### 如何访问wsl

```
使用\\wsl$
```

### 如何访问wsl docker 文件目录

```
\\wsl$\docker-desktop-data\version-pack-data\community
```

### 如何将Windows硬盘挂载至wsl2中

```powershell
# 查看硬盘
GET-CimInstance -query "SELECT * from Win32_DiskDrive"
# 获取硬盘标识
win 11 才能玩，gg

```

### 关于windows wsl docker的数据存储和迁移

```
docker-desktop启动后会生成两个发行版
docker-desktop-data 用于存放docker数据
docker-desktop 是docker wsl 的基础运行环境

停止 Docker 进程
关闭所有发行版： wsl --shutdown
导出 docker-desktop-data 发行版： wsl --export docker-desktop-data D:\wsl\docker\tmp\docker-desktop-data.tar
注销 docker-desktop-data 发行版： wsl --unregister docker-desktop-data
导入 docker-desktop-data 到期望迁移的目录： wsl --import docker-desktop-data D:\wsl\docker\data\ D:\wsl\docker\tmp\docker-desktop-data.tar --version 2 （迁移目录 D:\wsl\docker\data\ 可根据个人需求修改）
（可选）删除第 3 步导出的临时文件： D:\wsl\docker\tmp\docker-desktop-data.tar
（可选）另一个 Docker 发行版 docker-desktop 可使用同样方式迁移，但是其占用空间很小，不迁移亦可
迁移完成后可发现 %LOCALAPPDATA%/Docker/wsl 目录下的发行版文件已被删除， C 盘空间已释放
```

```powershell
# wsl2_move_docker_image.ps1
# Docker 镜像存储位置一键迁移脚本（适用于 WSL2 版本）
#
# Powershell Script 3.0+
# ---------------------------------------------------------------------------------------
# 脚本使用方式（需使用管理员权限执行）:
#   .\wsl2_move_docker_image.ps1 -target "D:\wsl\docker"
# ---------------------------------------------------------------------------------------
#
# target: 期望迁移的目录
param([string]$target="D:\wsl\docker")

New-Item -ItemType Directory -Path "$target\tmp"
New-Item -ItemType Directory -Path "$target\distro"
New-Item -ItemType Directory -Path "$target\data"

Write-Host "Stop docker ..."
net stop "com.docker.service"

Write-Host "Stop wsl ..."
wsl --shutdown

Write-Host "Move docker-desktop-data image ..."
wsl --export docker-desktop-data $target\tmp\docker-desktop-data.tar
wsl --unregister docker-desktop-data
wsl --import docker-desktop-data $target\data\ $target\tmp\docker-desktop-data.tar --version 2

Write-Host "Move docker-desktop image ..."
wsl --export docker-desktop $target\tmp\docker-desktop.tar
wsl --unregister docker-desktop
wsl --import docker-desktop $target\distro\ $target\tmp\docker-desktop.tar --version 2

Write-Host "Finish."
```

```powershell
# Debian 导出
$target="D:\wsl\Debian"
New-Item -ItemType Directory -Path "$target\tmp"
New-Item -ItemType Directory -Path "$target\distro"

wsl --export Debian $target\tmp\d.tar
wsl --unregister Debian
wsl --import Debian $target\distro\ $target\tmp\d.tar --version 2
```

