## 系统

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
openssl req -key /etc/pki/CA/private/cakey.pem -new -x509 -days 7300 -sha256 -extensions v3_ca -out /etc/pki/CA/cacert.pem // CA生成自签名证书，这个证书是自签名的根证书

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

