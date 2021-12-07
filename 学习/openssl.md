```
openssl 由于版本和漏洞，现linux多采用libressl

因openssl 1.0.1存在安全问题，python3自3.7版本后要求依赖openssl 1.0.2以上或libressl；错误提示如下：

Python requires an OpenSSL 1.0.2 or 1.1 compatible libssl with X509_VERIFY_P

python3.7以上建议使用libressl代替openssl，故需通过源码编译安装libressl

# 下载源码包

wget https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.0.2.tar.gz

# 解压

tar -zxvf libressl-3.0.2.tar.gz

# 配置安装路径

mkdir /usr/local/libressl
cd libressl-3.0.2

./configure --prefix=/usr/local/libressl --exec-prefix=/usr/local/libressl
# 安装

make & make install

# 创建软连接代替openssl,如果只是为了编译Python，下列操作不必须

mv /usr/bin/openssl /usr/bin/openssl.bak

mv /usr/include/openssl /usr/include/openssl.bak

ln -s /usr/local/libressl/bin/openssl /usr/bin/openssl
ln -s /usr/local/libressl/include/openssl /usr/include/openssl
echo /usr/local/libressl/lib >> /etc/ld.so.conf.d/libressl-3.0.2.conf
ldconfig -v
验证是否安装完成

openssl version
# 不用加环境变量
配置编译安装python

./configure --prefix=/usr/local/python3 --with-openssl=/usr/local/libressl
make

make install

验证ssl 安装正确

import ssl没有报错

include ld.so.conf.d/*.conf
/lib
/usr/lib
/usr/lib64
/usr/local/lib

```

