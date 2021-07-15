# k8s集群部署

## 使用资源

虚拟机三台

| IP | 配置 |	系统版本 | 角色 | 部署组件 |
| --------------- | ----------------------- | ---- | -- | --------------- |
| 192.168.202.159 | 4C/8G/500G | CentOS7.9 | Master、nfs fileserver、CA、etcd | kube-apiserver，kube-controller-manager，kube-scheduler，kubelet，kube-proxy，docker，etcd，nginx，keepalived |
| 192.168.202.59  | 4C/8G/100G | CentOS7.9 | Master,etcd | kube-apiserver，kube-controller-manager，kube-scheduler，kubelet，kube-proxy，docker，etcd，nginx，keepalived |
| 192.168.202.79  | 4C/8G/100G | CentOS7.9 | worknode,etcd | kubelet，kube-proxy，docker，etcd |

## 机器准备工作

```shell
# 192.168.202.159
hostnamectl set-hostname k8s-m0
# 192.168.202.59
hostnamectl set-hostname k8s-m1
# 192.168.202.79
hostnamectl set-hostname k8s-n0

# 在master添加hosts，在所有服务器添加
cat >> /etc/hosts << EOF 
192.168.202.159 k8s-m0
192.168.202.59 k8s-m1 
192.168.202.79 k8s-n0 
EOF

# 在三台机器进行以下操作
# 关闭防火墙和selinux 或放开selinux限制
systemctl stop firewalld && systemctl disable firewalld
# 临时关闭 selinux
setenforce 0 
# 永久关闭 selinux
vi /etc/selinux/config 配置 SELINUX=disabled
# 或
sed -i 's/enforcing/disabled/' /etc/selinux/config

# 查看ftype是否为1
xfs_info /dev/centos/root

# 查看各台机器网卡，硬件是否唯一，使用ifconfig 查询在使用网卡,并查询/sys/class/net目录下网卡地址
# 网络工具包下载 
yum install net-tools
# 网卡地址
cat /sys/class/net/ens192/address
# 硬件
cat /sys/class/dmi/id/product_uuid

# 禁用swap
# 临时 swapoff -a
# 永久 
vi /etc/fstab # 注释 swap行

lsmod | grep br_netfilter 查看 br_netfilter 模块是否启用

sysctl -a | grep net.bridge.bridge #查看是否有以下配置 将桥接的IPv4流量传递到iptables的链
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
# 若无则设置，主要等于号两边不要有空格，否则会宝座sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-iptables : No such file or directory
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
```

## 自签发多IP，多域名的证书

```shell
# 用OpenSSL配置带有SubjectAltName的ssl请求

# 对于多域名，只需要一个证书就可以保护非常多的域名。
# SubjectAltName是X509 Version 3 (RFC 2459)的扩展，允许ssl证书指定多个可以匹配的名称。
# SubjectAltName 可以包含email 地址，ip地址，正则匹配DNS主机名，等等
# ssl这样的一个特性叫做：SubjectAlternativeName（简称：san）
# openssl 配置路径 /etc/pki/tls/openssl.cnf
# 找到req段落。这段落的内容将会告诉openssl如何去处理证书请求（CSR），添加以下内容
[ req ]
req_extensions = v3_req
# 找到 [ v3_req ] 部分，添加 
subjectAltName = @alt_names
# 添加alt_names部分
[alt_names]
DNS.1 = k8s.sczq.com
IP.1 = 192.168.202.159
IP.2 = 192.168.202.59
IP.3 = 192.168.202.79
IP.4 = 192.168.202.158
# 创建csr.conf
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = CN
ST = Beijing
L = Beijing
O = <organization>
OU = <organization unit>
CN = <MASTER_IP>

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster
DNS.5 = kubernetes.default.svc.cluster.local
IP.1 = <MASTER_IP>
IP.2 = <MASTER_CLUSTER_IP>

[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=keyEncipherment,dataEncipherment
extendedKeyUsage=serverAuth,clientAuth
subjectAltName=@alt_names


# 创建私钥 
openssl genrsa -out /etc/pki/CA/private/cakey.pem
# 创建请求文件
openssl req -new -key private/cakey.pem -extensions v3_req -out ca.csr
# 自签名并创建CA证书
openssl x509 -req -days 3650 -in ca.csr -signkey private/cakey.pem -extensions v3_req -out cacert.pem

# 签名颁发证书
openssl genrsa -out /etc/pki/CA/private/k8s-key.pem
openssl req -new -key private/k8s-key.pem -extensions v3_req -out k8s.csr
openssl x509 -req -extfile /etc/pki/tls/openssl.cnf -extensions v3_req -CA cacert.pem -CAkey private/cakey.pem -CAcreateserial -in k8s.csr -out certs/k8s-cert.pem
```

## 安装etcd

```shell
# 在home目录下建一个downloads目录，存放下载文件
# 以下在节点1上操作，为简化操作，待会将节点1生成的所有文件拷贝到其他节点.
wget https://github.com/etcd-io/etcd/releases/download/v3.5.0/etcd-v3.5.0-linux-amd64.tar.gz
cd /home/downloads
mkdir /opt/etcd/{bin,cfg,ssl} -p
tar zxvf etcd-v3.5.0-linux-amd64.tar.gz
mv etcd-v3.5.0-linux-amd64/{etcd,etcdctl,etcdutl} /opt/etcd/bin
# 创建etcd配置文件
cat > /opt/etcd/cfg/etcd.conf << EOF
#[Member]
ETCD_NAME="etcd-1"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://192.168.202.159:2380"
ETCD_LISTEN_CLIENT_URLS="https://192.168.202.159:2379"

#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://192.168.202.159:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://192.168.202.159:2379"
ETCD_INITIAL_CLUSTER="etcd-1=https://192.168.202.159:2380,etcd-2=https://192.168.202.59:2380,etcd-3=https://192.168.202.79:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
EOF

# ETCD_NAME：节点名称，集群中唯一
# ETCD_DATA_DIR：数据目录
# ETCD_LISTEN_PEER_URLS：集群通信监听地址
# ETCD_LISTEN_CLIENT_URLS：客户端访问监听地址
# ETCD_INITIAL_ADVERTISE_PEERURLS：集群通告地址
# ETCD_ADVERTISE_CLIENT_URLS：客户端通告地址
# ETCD_INITIAL_CLUSTER：集群节点地址
# ETCD_INITIALCLUSTER_TOKEN：集群Token
# ETCD_INITIALCLUSTER_STATE：加入集群的当前状态，new是新集群，existing表示加入已有集群

# 使用systemctl 管理etcd
cat > /usr/lib/systemd/system/etcd.service << EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
EnvironmentFile=/opt/etcd/cfg/etcd.conf
ExecStart=/opt/etcd/bin/etcd \
--cert-file=/opt/etcd/ssl/k8s-cert.pem \
--key-file=/opt/etcd/ssl/k8s-key.pem \
--peer-cert-file=/opt/etcd/ssl/k8s-cert.pem \
--peer-key-file=/opt/etcd/ssl/k8s-key.pem \
--trusted-ca-file=/opt/etcd/ssl/cacert.pem \
--peer-trusted-ca-file=/opt/etcd/ssl/cacert.pem \
--logger=zap
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# 添加证书
cp /etc/pki/CA/cacert.pem /etc/pki/CA/certs/k8s-cert.pem /etc/pki/CA/private/cakey.pem /etc/pki/CA/private/k8s-key.pem /opt/etcd/ssl/

# 启动服务设置开机自启动
systemctl daemon-reload
systemctl start etcd
systemctl enable etcd

# 复制etcd相关文件到其他节点，例
scp -r /opt/etcd/ root@192.168.202.59:/opt/
scp /usr/lib/systemd/system/etcd.service root@192.168.202.59:/usr/lib/systemd/system

# 修改etcd.conf
vi /opt/etcd/cfg/etcd.conf
#[Member]
ETCD_NAME="etcd-1"   # 修改此处，节点2改为etcd-2，节点3改为etcd-3
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://192.168.202.59:2380"   # 修改此处为当前服务器IP
ETCD_LISTEN_CLIENT_URLS="https://192.168.202.59:2379" # 修改此处为当前服务器IP

#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://192.168.202.59:2380" # 修改此处为当前服务器IP
ETCD_ADVERTISE_CLIENT_URLS="https://192.168.202.59:2379" # 修改此处为当前服务器IP
ETCD_INITIAL_CLUSTER="etcd-1=https://192.168.202.159:2380,etcd-2=https://192.168.202.59:2380,etcd-3=https://192.168.202.79:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"


```

# 安装docker
yum install -y yum-utils device-mapper-persistent-data lvm2

reboot

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
