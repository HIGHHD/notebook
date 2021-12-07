### Docker服务器

**安装**

```
# 在三台机器进行以下操作
# 关闭防火墙和selinux 或放开selinux限制
systemctl stop firewalld && systemctl disable firewalld
# 临时关闭 selinux
setenforce 0 
# 永久关闭 selinux
vi /etc/selinux/config 配置 SELINUX=disabled
# 或
sed -i 's/enforcing/disabled/' /etc/selinux/config

# 禁用swap
# 临时 swapoff -a
# 永久 
vi /etc/fstab # 注释 swap行

lsmod | grep br_netfilter 查看 br_netfilter 模块是否启用
#若未启用
modprobe br_netfilter

sysctl -a | grep net.bridge.bridge #查看是否有以下配置 将桥接的IPv4流量传递到iptables的链
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
# 若无则设置，主要等于号两边不要有空格，否则会报错sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-iptables : No such file or directory
sysctl -w "net.bridge.bridge-nf-call-ip6tables=1"
sysctl -w "net.bridge.bridge-nf-call-iptables=1"
# 生效配置
sysctl --system
# 时间同步
yum install ntpdate -y 
ntpdate 202.120.2.101 # 上海交通大学网络中心NTP服务器地址

# 若有docker，卸载之
systemctl stop docker.socket && systemctl stop docker
systemctl disable docker.socket && systemctl disable docker
yum remove docker docker-common docker-selinux docker-engine -y
yum remove docker-ce docker-ce-cli containerd.io docker-compose -y

# 下载repo安装docker
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
yum -y install docker-ce
# 启动docker
systemctl enable docker && systemctl start docker
```

**/etc/docker/deamon.json**

```\
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "data-root": "/home/docker",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file":"3"
  },
  "insecure-registries": ["172.21.199.1:5001"],
  "registry-mirrors": ["https://b9pmyelo.mirror.aliyuncs.com"]
}
```



### springboot镜像

**Dockerfile**

```
FROM openjdk:8u302-jre-slim-buster

RUN echo "Asia/Shanghai" > /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

WORKDIR /home
VOLUME ["/home"]
CMD ["bash"]
```

**用途**

用来运行springboot jar包， spring-jar volume用来存放需要运行的jar包

### tomcat镜像

**Dockerfile**

```
FROM tomcat:8.5-jre8-openjdk-slim-buster

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&  echo "Asia/Shanghai" > /etc/timezone && mkdir -p /files

VOLUME ["/files", "/usr/local/tomcat/webapps", "/usr/local/tomcat/conf"]

WORKDIR /usr/local/tomcat/webapps
CMD ["catalina.sh", "run"]
```

**用途**

用来运行tomcat war包， tomcat-war volume用来存放需要运行的war包 tomcat-data 用来存放程序的上传下载文件

### nginx镜像

**Dockerfile**

```
FROM nginx:1.21.1-alpine-perl

RUN apk add tzdata \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone 

VOLUME ["/etc/nginx", "/srv"]

EXPOSE 80
```

**用途**

用来提供纯前端服务，nginx_srv volume用来存放需要运行的静态文件 nginx_conf 用来存放nginx配置

### apache镜像

**Dockerfile**

```
FROM php:7.2.8-apache
RUN echo "Asia/Shanghai" > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Universal /etc/localtime

VOLUME ["/srv", "/etc/apache2", "/home", "/usr/local/etc/php"]

EXPOSE 80 8001 8002 8003 8004 8005
CMD ["apache2-foreground"]
```

**用途**

用来提供php网站服务，各volume作用：phpapache_conf（apache配置）、phpapache_php_conf（php配置）、 phpapache_srv（网站服务文件）、phpapache_data（网站资源文件）

### python镜像

**Dockerfile**

```
FROM python:buster

COPY ./requirements.txt /home/

RUN echo "Asia/Shanghai" > /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    sed -i s/deb.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list && \
    sed -i s/security.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list && \
    apt-get update && apt install -y libpq5

RUN pip3 install -r /home/requirements.txt

WORKDIR /srv

VOLUME ["/srv", "/home"]
EXPOSE 1338
```

**用途**

python程序运行环境，文档中心、报表中心后台
