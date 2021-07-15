重装7.8后，ssd一块 200G 68G 系统 2G swap (系统会禁用) 预留用来安装docker  raid0 4块 584G (计划存放数据)

装系统时留120g ssd空间不要分配，留待后续操作，如若已分陪数据区，重装系统,也可以忽略
```
fdisk /dev/sda
reboot
pvcreate /dev/sda3

vgextend centos /dev/sda3

lvextend /dev/centos/root /dev/sda3

xfs_growfs /dev/centos/root

xfs_info /dev/centos/root 查看ftype是否为1
df -Th验证 

lsmod |grep overlay 查看是否加载overlay module 若未加载 则执行 echo "overlay" > /etc/modules-load.d/overlay.conf && modprobe overlay
reboot

数据盘处理

fdisk /dev/sdb
reboot

pvcreate /dev/sdb1
vgcreate vgdata /dev/sdb1
lvcreate --name mydata -l 100%FREE vgdata

mkfs.xfs -n ftype=1 /dev/vgdata/mydata

cd / && mkdir mydata
chmod -R 777 /mydata

vi /etc/fstab
/dev/mapper/vgdata-mydata /mydata  xfs     defaults      0 0

reboot

yum install -y yum-utils
yum install -y device-mapper-persistent-data lvm2 //最小化版本已安装

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
	
yum install docker-ce docker-ce-cli containerd.io -y
```

>参考 https://docs.docker.com/engine/install/centos/

```
systemctl start docker && systemctl enable docker

docker info 查看docker信息
```

添加镜像加速

```
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://fl791z1h.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload && systemctl restart docker
```

k8s安装

参考文档 
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
https://www.kubernetes.org.cn/7189.html

```
192.168.1.168
hostnamectl set-hostname k8s-m0

192.168.1.169
hostnamectl set-hostname k8s-n0
```

```
关闭防火墙和selinux 或放开selinux限制
systemctl stop firewalld && systemctl disable firewalld
setenforce 0
vi /etc/selinux/config  SELINUX=permissive
reboot

查看网卡，硬件是否唯一
cat /sys/class/net/em1/address
cat /sys/class/dmi/id/product_uuid

禁用swap

临时 swapoff -a
永久 vi /etc/fstab 注释 swap行

lsmod | grep br_netfilter 查看 br_netfilter 模块是否启用

sysctl -a | grep net.bridge.bridge 查看 是否有以下配置 将桥接的IPv4流量传递到iptables的链
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1


cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubelet kubeadm kubectl
systemctl enable kubelet

kubelet --version 获取version

kube init 主节点参考
https://kubernetes.io/zh/docs/reference/setup-tools/kubeadm/kubeadm-init/

kubeadm init --kubernetes-version=1.19.4  \
--apiserver-advertise-address=192.168.1.168  \
--image-repository registry.aliyuncs.com/google_containers  \
--service-cidr=10.96.0.0/12 --pod-network-cidr=10.122.0.0/16

10.96.0.0/12 为默认值
由于kubeadm 默认从官网k8s.grc.io下载所需镜像，国内无法访问，因此需要通过–image-repository指定阿里云镜像仓库地

安装成功后的提示


To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.168:6443 --token 4nkd1h.e19ycbhiri3ppd0x \
    --discovery-token-ca-cert-hash sha256:1d52ae1f209931bb8f4db8d1474e813a8517dd0f2545c29fd6dfdfb5961b2244



根据提示创建kubelet
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

执行下面命令，使kubectl可以自动补充
source <(kubectl completion bash)

查看节点 pod

kubectl get node
kubectl get pod --all-namespaces

node节点为NotReady，因为corednspod没有启动，缺少网络pod

安装calico网络 参考文档 https://docs.projectcalico.org/getting-started/kubernetes/minikube
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml


过1分钟左右查看节点 pod

kubectl get node
kubectl get pod --all-namespaces
此时状态Ready

安装kubernetes-dashboard
官方部署dashboard的服务没使用nodeport，将yaml文件下载到本地，在service里添加nodeport

wget  https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc7/aio/deploy/recommended.yaml
域名解析有误
vi /etc/hosts 添加 151.101.76.133 raw.githubusercontent.com

更改kubernetes-dashboard Service如下

kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  type: NodePort
  ports:
    - port: 443
      targetPort: 8443
      nodePort: 30000
  selector:
    k8s-app: kubernetes-dashboard
	
kubectl 参考
https://kubernetes.io/zh/docs/reference/kubectl/overview/

执行 kubectl describe secrets -n kubernetes-dashboard
找到 Type为  kubernetes.io/service-account-token 块下的token

访问 https://192.168.1.168:30000/
使用上一步的token登录，登录后发现没有资源，是因为用户没有绑定权限

rbac 参考 https://kubernetes.io/zh/docs/reference/access-authn-authz/rbac/

dashboard rbac参考 https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

执行
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF


cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

延长token时间 arg处 设置参数--token-ttl=0

执行 kubectl describe secrets -n kubernetes-dashboard

找到admin-user token 重新登录
或直接执行 kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}') 获取token

添加节点参考
https://kubernetes.io/zh/docs/reference/setup-tools/kubeadm/kubeadm-join/

同主节点安装，安装完成后执行

systemctl enable kubelet && systemctl start kubelet

加入集群
kubeadm join 192.168.1.168:6443 --token 4nkd1h.e19ycbhiri3ppd0x --discovery-token-ca-cert-hash sha256:1d52ae1f209931bb8f4db8d1474e813a8517dd0f2545c29fd6dfdfb5961b2244


eyJhbGciOiJSUzI1NiIsImtpZCI6ImlycEltMVM1TzBKYnh0c1N2MTVQS0ZxajNIdENJU21vVl9aLUpyMEVhZFkifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLWNmazJuIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJlNjBkY2M0MS03ZGJjLTRkMzctOWY5ZC1kYTAxNzg4MGU0ZmEiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.Popd3e0EMyP38pjW9WxWK-7HHHSWp6u-jkgJQJ0gqQj1D9A3JPqnIfpV2FXR97Sc13bXgZJqtWCFoljScS4zDbYlziqyFAqrK_lkKp_Z0_L77lN1l9ziz3etYGNtWyeSZ0ecO6JleVcm-y0d4MRVE81zUvjIRud0T4o2EkE2tn5mbUqsAQBeaKz0ustbJ3DLqvSPmg-UoUZ5cWnLoZmPMY3-y9d3ZdshAeolO0gN_7-Gt4UqIqksq6PDQuaaoVCEPFQBLL31esNa--8cy3XTkINs4ByifP0bWjHtZyKGndg651RMs6Ctsjv0vvz5Gs84rd7z8OHRkJH7nsT824GGkQ

git root pwd
DEtRtpw40Vw5Dpusz6ZGQhM7XrnNeSyT84e19uQh9YTsLz1sd0lrWU166dm2JtSl

持久卷
kube-apiserver，有不同的启动方式，这里是pod
开启动态供应支持，取代recycle回收策略
编辑/etc/kubernetes/manifests/kube-apiserver.yaml，--enable-admission-plugins选项以逗号分隔，添加DefaultStorageClass，kubelet会监听这个配置文件，更改后保存即可

并不是所有的api资源都位于namespace
kubectl api-resources --namespaced=true false

StorageClass
helm repo add ckotzbauer https://ckotzbauer.github.io/helm-charts
helm install my-nfs --set nfs.server=192.168.1.169 --set nfs.path=/mydata/k8s ckotzbauer/nfs-client-provisioner --version 1.0.2

StorageClass

PV是运维人员来创建的，开发操作PVC，可是大规模集群中可能会有很多PV，如果这些PV都需要运维手动来处理这也是一件很繁琐的事情，所以就有了动态供给概念，也就是Dynamic Provisioning。而我们上面的创建的PV都是静态供给方式，也就是Static Provisioning。而动态供给的关键就是StorageClass，它的作用就是创建PV模板。

创建StorageClass里面需要定义PV属性比如存储类型、大小等；另外创建这种PV需要用到存储插件。最终效果是，用户提交PVC，里面指定存储类型，如果符合我们定义的StorageClass，则会为其自动创建PV并进行绑定。
```

```
redis

NAME: my-redis
LAST DEPLOYED: Mon Nov 23 10:31:45 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
** Please be patient while the chart is being deployed **
Redis can be accessed via port 6379 on the following DNS names from within your cluster:

my-redis-master.default.svc.cluster.local for read/write operations
my-redis-slave.default.svc.cluster.local for read-only operations


To get your password run:

    export REDIS_PASSWORD=$(kubectl get secret --namespace default my-redis -o jsonpath="{.data.redis-password}" | base64 --decode)

To connect to your Redis server:

1. Run a Redis pod that you can use as a client:
   kubectl run --namespace default my-redis-client --rm --tty -i --restart='Never' \
    --env REDIS_PASSWORD=$REDIS_PASSWORD \
   --image docker.io/bitnami/redis:6.0.9-debian-10-r13 -- bash

2. Connect using the Redis CLI:
   redis-cli -h my-redis-master -a $REDIS_PASSWORD
   redis-cli -h my-redis-slave -a $REDIS_PASSWORD

To connect to your database from outside the cluster execute the following commands:

    kubectl port-forward --namespace default svc/my-redis-master 6379:6379 &
    redis-cli -h 127.0.0.1 -p 6379 -a $REDIS_PASSWORD

```

helm

helm get nodes <> 可以获取到安装信息


ingress 

重复安装可能报错，需要执行
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission


网络层参考
https://blog.csdn.net/yang75108/article/details/101268208


Service "my-redis-master" is invalid: spec.ports[0].nodePort: Forbidden: may not be used when `type` is 'ClusterIP'

kubectl delete pvc 
kubectl delete secret $(kubectl get secret|grep gitlab | awk '{print $1}')


https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx
To use, add the kubernetes.io/ingress.class: nginx annotation to your Ingress resources.

```
    - --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
    - --requestheader-allowed-names=front-proxy-client
    - --requestheader-extra-headers-prefix=X-Remote-Extra-
    - --requestheader-group-headers=X-Remote-Group
    - --requestheader-username-headers=X-Remote-User
```