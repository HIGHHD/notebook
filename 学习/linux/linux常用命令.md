系统

```shell
uname -a	// 查看linux内核版本
cat /etc/redhat-release	// 查看centos版本
yum upgrade kernel	// 升级内核
reboot 
删除旧的内核：package-cleanup --oldkernels --count=1
yum clean all
yum update	// 升级centos
reboot
```

## CA证书颁发

```shell
openssl version // 查看版本
yum install openssl-devel // 安装openssl

openssl 配置路径 /etc/pki/tls/openssl.cnf
cd /etc/pki/CA
echo 01 > /etc/pki/CA/serial //指定第一个颁发证书的序列号
echo 01 > /etc/pki/CA/crlnumber //指定第一个吊销证书的序列号
touch /etc/pki/CA/index.txt //建立ca的证书库
该目录下几个文件夹的作用
/etc/pki/CA/certs  #  已颁发证书的保存位置
/etc/pki/CA/crl    # 吊销的证书存放目录
/etc/pki/CA/newcerts # 存放CA签署（颁发）过的数字证书（证书备份目录）
/etc/pki/CA/private  # 用于存放CA的私钥

openssl genrsa -out /etc/pki/CA/private/cakey.pem	// 生成根证书密钥
openssl req -key /etc/pki/CA/private/cakey.pem -new -x509 -days 3650 -sha256 -extensions v3_ca -out /etc/pki/CA/cacert.pem // CA生成自签名证书，这个证书是自签名的根证书

以上就完成了根证书的相关操作，下一步可以颁发证书了。生成和签发服务器身份验证证书，注意证书是自签名的，浏览器会提示不受信任
》 查看证书 openssl x509 -in ***.pem -text -noout

》 颁发证书
1. 在需要使用证书的主机上给服务器生成私钥
openssl genrsa -out /etc/pki/tls/ private/s1-key.pem 2048
2. 在需要使用证书的主机上给服务器生成证书请求
openssl req -new -key /etc/pki/tls/private/test.key   -days 365 -out /etc/pki/tls/s1.csr
国家、省、公司要与CA一致
3. 将请求文件传给CA(192.168.202.159)
scp /etc/pki/tls/s1.csr 192.168.202.159:/etc/pki/CA/csrtemp
4. CA签署证书，并将证书颁发给请求者
openssl ca -in /etc/pki/CA/csrtemp/s1.csr -out /etc/pki/CA/certs/s1-cert.pem -days 3650
scp /etc/pki/CA/certs/s1-cert.pem 192.168.202.59:/etc/pki/tls

》 吊销证书
1. 在客户端获取要吊销的证书的serial
openssl x509 -in /etc/pki/CA/certs/s1-cert.pem -noout -serial -subject
2. 在CA上，根据客户提交的serial和subject详细，比对检验是否与index.txt文件中的信息一致，一致则吊销证书
openssl ca -revoke /etc/pki/CA/certs/s1-cert.pem
3. CA更新证书吊销列表
openssl ca -gencrl -out /etc/pki/CA/crl/crl.pem

》 自签发多IP，多域名的证书
用OpenSSL配置带有SubjectAltName的ssl请求

对于多域名，只需要一个证书就可以保护非常多的域名。
SubjectAltName是X509 Version 3 (RFC 2459)的扩展，允许ssl证书指定多个可以匹配的名称。
SubjectAltName 可以包含email 地址，ip地址，正则匹配DNS主机名，等等
ssl这样的一个特性叫做：SubjectAlternativeName（简称：san）

找到req段落。这段落的内容将会告诉openssl如何去处理证书请求（CSR），添加以下内容
[ req ]
req_extensions = v3_req
找到 [ v3_req ] 部分，添加 
subjectAltName = @alt_names
添加alt_names部分
[alt_names]
DNS.1 = kb.example.com
DNS.2 = helpdesk.example.org
DNS.3 = systems.example.net
IP.1 = 192.168.1.1
IP.2 = 192.168.69.14

创建私钥 
openssl genrsa -out /etc/pki/CA/private/cakey.pem
创建请求文件
openssl req -new -key private/cakey.pem -extensions v3_req -out ca.csr
自签名并创建CA证书
openssl x509 -req -days 3650 -in ca.csr -signkey private/cakey.pem -extfile /etc/pki/tls/openssl.cnf -extensions v3_req -out cacert.pem

签名颁发证书
openssl genrsa -out /etc/pki/CA/private/k8s-key.pem
openssl req -new -key private/k8s-key.pem -extensions v3_req -out k8s.csr
openssl x509 -req -extfile /etc/pki/tls/openssl.cnf -extensions v3_req -CA cacert.pem -CAkey private/cakey.pem -CAcreateserial -in k8s.csr -out certs/k8s-cert.pem


```

## 分区

### 将home分区和root分区合并

```shell
# 把/home内容备份，然后将/home文件系统所在的逻辑卷删除，扩大/root文件系统，新建/home：
tar cvf /tmp/home.tar /home    #备份/home  没东西可以不备份
# 记录一下 home下有多少可用空间  ，比如2G
umount /home    #卸载/home，如果无法卸载，先终止使用/home文件系统的进程
lvremove /dev/centos/home    # 删除/home所在的lv
lvextend -l +100%FREE /dev/centos/root    # 扩展/root所在的lv，增加/home的大小
xfs_growfs /dev/centos/root    #扩展/root文件系统
df -h # 查询新分区
```

## IP配置

```
cd /etc/sysconfig/network-scripts
vi ifcfg-网卡
systemctl daemon-reload
systemctl restart network
```

## sed

```shell
sed -i s/deb.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list
sed -i s/security.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list
```

http://security.debian.org/debian-security


## 文件权限

在linux系统中,文件或目录的权限可以分为3种:

r:4 读

w:2 写

x:1  执行(运行)
－：对应数值0

数字 4 、2 和 1表示读、写、执行权限

rwx = 4 + 2 + 1 = 7 (可读写运行）

rw = 4 + 2 = 6 （可读写不可运行）

rx = 4 +1 = 5 （可读可运行不可写）

示例:

最高权限777:(4+2+1) (4+2+1)  (4+2+1)

第一个7:表示当前文件的拥有者的权限,7=4+2+1 可读可写可执行权限

第二个7:表示当前文件的所属组（同组用户）权限,7=4+2+1 可读可写可执行权限

第三个7:表示当前文件的组外权限,7=4+2+1 可读可写可执行权限



## 文件共享

```
exportfs -arv //重新加载 /etc/exports文件的配置
```
\\192.168.202.23\home\for_mount\oais_ftpdata

exports文件中可以设定的参数主要有以下这些：

(1) ro 该主机对该共享目录有只读权限

(2) rw 该主机对该共享目录有读写权限

(3) root_squash 客户机用root用户访问该共享文件夹时，将root用户映射成匿名用户

(4) no_root_squash 客户机用root访问该共享文件夹时，不映射root用户

(5) all_squash 客户机上的任何用户访问该共享目录时都映射成匿名用户

(6) anonuid 将客户机上的用户映射成指定的本地用户ID的用户

(7) anongid 将客户机上的用户映射成属于指定的本地用户组ID

(8) sync 资料同步写入到内存与硬盘中

(9) async 资料会先暂存于内存中，而非直接写入硬盘

(10) insecure 允许从这台机器过来的非授权访问　

(11) subtree_check 如果共享/usr/bin之类的子目录时，强制NFS检查父目录的权限（默认）

(12) no_subtree_check 和上面相对，不检查父目录权限

(13) wdelay 如果多个用户要写入NFS目录，则归组写入（默认）

(14 )no_wdelay 如果多个用户要写入NFS目录，则立即写入，当使用async时，无需此设置。

(15) hide 在NFS共享目录中不共享其子目录

(16) no_hide 共享NFS目录的子目录

(17) secure NFS通过1024以下的安全TCP/IP端口发送

(18) insecure NFS通过1024以上的端口发送



## tar

tar -zxvf go1.17.linux-amd64.tar.gz  -C /usr/local/ 解压文件到指定目录



## ln

软连接 ln -s 源文件 目标文件



## 时间操作

timedatectl 操作时区，查看当前时间配置

 timedatectl set-timezone 'Asia/Shanghai'



将UTC时间作为本地时间

ln -sf /usr/share/zoneinfo/Universal /etc/localtime

## 查看cpu

```
lscpu
```

