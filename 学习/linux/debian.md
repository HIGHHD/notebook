设置阿里源，安装gcc，g++等

```shell
sed -i s/deb.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list && \
 sed -i s/security.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list && \
 apt-get update && apt-get install -y build-essential 
```



wsl修改root密码 sudo passwd



/bin目录（binary）是二进制执行文件目录，主要用于具体应用

/sbin目录（system binary）是系统管理员专用的二进制代码存放目录，主要用于系统管理

