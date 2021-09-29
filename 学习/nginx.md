```
yum -y install make zlib zlib-devel gcc-c++ libtool  openssl openssl-devel libxml2 libxml2-dev libxslt-devel gd-devel perl-devel perl-ExtUtils-Embed geoip-devel gperftools pcre pcre-devel
```

```
./configure --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --http-client-body-temp-path=/var/lib/nginx/tmp/client_body --http-proxy-temp-path=/var/lib/nginx/tmp/proxy --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi --http-scgi-temp-path=/var/lib/nginx/tmp/scgi --pid-path=/run/nginx.pid --lock-path=/run/lock/subsys/nginx --user=nginx --group=nginx --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module=dynamic --with-http_image_filter_module=dynamic --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --with-http_perl_module=dynamic --with-http_auth_request_module --with-mail=dynamic --with-mail_ssl_module --with-pcre --with-pcre-jit --with-stream=dynamic --with-stream_ssl_module --with-debug --add-module=/path/to/ngx_http_proxy_connect_module
```

```
make && make install
```

```
Type=forking
PIDFile=/run/nginx.pid
# Nginx will fail to start if /run/nginx.pid already exists but has the wrong
# SELinux context. This might happen when running `nginx -t` from the cmdline.
# https://bugzilla.redhat.com/show_bug.cgi?id=1268621
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGQUIT
TimeoutStopSec=5
KillMode=process
PrivateTmp=true
[Install]
WantedBy=multi-user.target
```

编译安装后，若报错

```
nginx: [emerg] getpwnam("nginx") failed
```

是因为，安装时制定了用户和用户组

以下方式解决

```
useradd -s /sbin/nologin -M nginx
mkdir -p /var/cache/nginx/client_temp
mkdir -p /var/lib/nginx/tmp/client_body
```



# nginx正向代理

 

正向代理：局域网中的客户端不能直接访问Internet，则需要通过代理服务器来访问，这种代理服务就称为正向代理。Nginx本身只支持http的正向代理，并通过ngx_http_proxy_connect_module模块支持http、https的正向代理；
反向代理：如果局域网向Internet提供资源服务，让Internet上的其他客户端来访问局域网内不的资源，使它们必须通过一个代理服务器来进行访问内部资源，这种服务就称为反向代理；Nginx通过proxy模块实现反向代理功能。

假设现在的环境是，局域网中只有一台机器：192.168.10.154配有某个公网IP，如此可以直接访问公网，而其他局域网服务器需要通过154上的代理来访问公网： 

正向代理http：

1、# vim /etc/nginx/conf.d/proxy.conf

```
server {　　

    resolver 8.8.8.8; 
    listen 9999;
    access_log  /var/log/nginx/proxy.access.log main;
    error_log   /var/log/nginx/proxy.error.log;

    location / {

       proxy_pass $schema://$http_host$request_uri;
    
}
}
```

2、在需要访问公网的服务器配置环境变量

\# vim /etc/profile
export http_proxy=http://192.168.10.154:9999

\# source /etc/profile

 

yum源配置：

\# vim /etc/yum.conf   
proxy=http://192.168.10.154:9999

 

通过curl指定代理来测试http串是否返回200

\# curl -x 192.168.10.154:9999 -I http://xxxx.xxxx.xxxx/xxx.xxx

 

3、不支持代理 Https 网站

作为 web_server Nginx 当然是可以处理 ssl  的，但作为proxy则是不行的。因为nginx不支持CONNECT，收到“CONNECT /:443  HTTP/1.1”后会报一个包含“client sent invalid request while reading client  request line,” 的错误。因为 CONNECT 是正向代理的特性。

例：

访问：# curl -I -x 192.168.10.154:9999 'https://www.baidu.com/?tn=93380420_hao_pg'

日志：192.168.10.X - [04/Nov/2017:10:23:46 +0800] "CONNECT www.baidu.com:443 HTTP/1.1" 400 173 "-" "-" - - - - "-"

 

那么，如何让nginx的正向代理，既支持http又支持https的代理访问呢？

需要安装模块：ngx_http_proxy_connect_module

1、安装

```
https://github.com/chobits/ngx_http_proxy_connect_module/tree/master

$ cd nginx-1.9.2/
$ patch -p1 < /path/to/ngx_http_proxy_connect_module/patch/proxy_connect.patch
$ ./configure --add-module=/path/to/ngx_http_proxy_connect_module
$ make && make install
```



```
./configure --add-module=/path/to/ngx_http_proxy_connect_module
make && make install
 
```

2、配置


```
server {

listen 3128;

     # dns resolver used by forward proxying
     resolver                       8.8.8.8;

     # forward proxy for CONNECT request
     proxy_connect;
     proxy_connect_allow            443 563;
     proxy_connect_connect_timeout  10s;
     proxy_connect_read_timeout     10s;
     proxy_connect_send_timeout     10s;
     
     proxy_ssl_protocols  SSLv3 TLSv1 TLSv1.1 TLSv1.2;
     proxy_ssl_server_name on;

     proxy_ssl_ciphers DEFAULT;
     \# forward proxy for non-CONNECT request
     location / {

         proxy_pass $schema://$http_host$request_uri;
         proxy_set_header Host $host;
     

}

 }
```