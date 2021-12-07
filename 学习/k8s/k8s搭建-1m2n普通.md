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
hostnamectl set-hostname k8s-n0
# 192.168.202.79
hostnamectl set-hostname k8s-n1

# 在master添加hosts，在所有服务器添加
cat >> /etc/hosts << EOF 
192.168.202.159 k8s-m0
192.168.202.59 k8s-n0 
192.168.202.79 k8s-n1 
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
ntpdate 172.21.2.104 #新机房

docker容器时间受宿主机影响

# 若有docker，卸载之
systemctl stop docker.socket && systemctl stop docker
systemctl disable docker.socket && systemctl disable docker
yum remove docker docker-common docker-selinux docker-engine -y
yum remove docker-ce docker-ce-cli containerd.io docker-compose -y
```

# 安装docker

```shell
# 下载repo安装docker
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
yum -y install docker-ce
# 启动docker
systemctl enable docker && systemctl start docker
```

## 安装k8s

```shell
# 添加阿里云YUM软件源
cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# 安装
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet

# 设置一下docker，处理告警、配置镜像下载加速器
mkdir /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file":"3"
  },
  "registry-mirrors": ["https://b9pmyelo.mirror.aliyuncs.com"]
}
EOF
systemctl enable docker && systemctl daemon-reload && systemctl restart docker

# harbor安装完，需要在/etc/docker/daemon.json添加私有仓库地址，例
"insecure-registries": ["https://192.168.202.159:30003"],

# 1.21.2 使用国内镜像报错，需要手动下载coredns并打标签
docker pull coredns/coredns
docker tag coredns/coredns:latest registry.aliyuncs.com/google_containers/coredns:v1.8.0
docker rmi coredns/coredns:latest
# init主节点
kubeadm init --kubernetes-version=1.21.2  \
--apiserver-advertise-address=192.168.202.159  \
--image-repository registry.aliyuncs.com/google_containers  \
--service-cidr=10.96.0.0/12 --pod-network-cidr=10.122.0.0/16 

# 执行完成会提示

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.202.159:6443 --token zjak8i.udmbuqdyfzgjute0 \
        --discovery-token-ca-cert-hash sha256:c241d54be7b4c66946eda43757c2f552a3e044ae94a57c3c7fa043a7ff169d05

# 根据提示执行
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# 执行下面命令，使kubectl可以自动补充
source <(kubectl completion bash)

# 查看节点 pod

kubectl get node
kubectl get pod --all-namespaces

# node节点为NotReady，因为corednspod没有启动，缺少网络pod

# 安装calico网络 参考文档 https://docs.projectcalico.org/getting-started/kubernetes/minikube
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# 过1分钟左右查看节点 pod
kubectl get node
kubectl get pod --all-namespaces
# 此时状态Ready

# 加入节点
kubeadm join 192.168.202.159:6443 --token zjak8i.udmbuqdyfzgjute0 \
        --discovery-token-ca-cert-hash sha256:c241d54be7b4c66946eda43757c2f552a3e044ae94a57c3c7fa043a7ff169d05

# 注：默认token有效期为24小时，当过期之后，该token就不可用了。这时就需要重新创建token，可以直接使用命令快捷生成：kubeadm token create --print-join-command
        
# Kubernetes集群中移除Node
# 在master节点上执行：
kubectl drain <node> --delete-emptydir-data --force --ignore-daemonsets
kubectl delete node <node>
# 在node上执行：
kubeadm reset

```

## k8s常用命令

> https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-strong-getting-started-strong-

```shell
# 查看
kubectl get
kubectl describe
```

## NFS安装

> https://www.kubernetes.org.cn/4022.html

```
 yum install -y nfs-utils rpcbind
 vim /etc/exports
 /home/k8s-nfs 192.169.202.0/24(rw,sync,insecure,no_subtree_check,no_root_squash)
 exportfs -avr
```



# 密码

eyJhbGciOiJSUzI1NiIsImtpZCI6IjFSb0FsdDFhWFl6Qm52c3l4djdLTGRYNEdwbFlZSmNmaFNyZVgxQzVsZTgifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLXJzc21oIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI1ZTUyMWI4Ni1mMWYzLTQzNGUtYTUwMi1mNDZkOTljMDFjMmUiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.qZhLekkMbvDIwSw-umpDkshxvNAIESx95NcVZc7RbFTJ8nUfr_SB-jkeTDwlC2CJES-CjV3QVU8p4lGH69n6aDI0-tbuMEfqW7pTUoZJFYLJFRSjk26vz7NFVfGqyiHzEJgBPOtXoOid-UTsPzcCKM1j9Vb4LhknGjhZ1dviE6bsqAY29ZL3-Vq3-ekjyYlw0Fw3DHiOqOenr6HqdPZGHKmlwnB5pXVK7RCUheyaF4bk6oz957QDzOBz-IA1Wqx6F56VIs2vQD5bpkIMoHyk6uz8MT9sTzF6g2yv2uPgSVCi3avVI15vCdzSwYNaCqG8ff0OQ7RjxFivUionwgLUaw



## 操作

```
helm repo add ckotzbauer https://ckotzbauer.github.io/helm-charts
// 设置该class为default
helm upgrade --install nfs-client-provisioner --set nfs.server=192.168.202.159 --set nfs.path=/home/k8s-nfs --set storageClass.defaultClass=true ckotzbauer/nfs-client-provisioner


helm upgrade --install -f redash.yaml redash redash/redash

在测试安装nfs-client-provisioner时发现，pv一直不能创建pod一直报错provision "default/cluster.local-nfs-client-provisioner" class "nfs-client": unexpected error getting claim reference: selfLink was empty, can't make reference

找了找资料发现，kubernetes 1.20版本 禁用了 selfLink。
解决方法

资料连接：
https://stackoverflow.com/questions/65376314/kubernetes-nfs-provider-selflink-was-empty
https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner/issues/25
当前的解决方法是编辑/etc/kubernetes/manifests/kube-apiserver.yaml
spec:
  containers:
  - command:
    - kube-apiserver
添加
- --feature-gates=RemoveSelfLink=false
Kubelet 会监听该文件的变化，会加载这个配置

// harbor admin 密码获取
kubectl get secret --namespace default harbor-core-envvars -o jsonpath="{.data.HARBOR_ADMIN_PASSWORD}" | base64 --decode
```

