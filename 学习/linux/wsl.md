子系统 \mnt目录下挂载了windows的硬盘驱动器

子系统和windows共享端口

设置默认登录用户为root

```powershell
debian config --default-user root
```

设置默认安装版本为2，当新安装linux时
```
wsl --set-default-version 2 
```

转换分发版本
```powershell
wsl --set-version Debian 2
```

windows terminal

> https://zhuanlan.zhihu.com/p/272082726

Ctrl + Shift + T  打开默认配置文件的新标签
Ctrl + Shift + N  打开其他个人资料的标签，其中N是个人资料的编号
Alt + Shift + D  复制并拆分窗格，每次使用时，活动窗格都会沿最长轴分成两部分

强制创建：

垂直窗格中，按 `Alt + Shift + + `或水平窗格，按 `Alt + Shift + -`