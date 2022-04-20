# node_exporter

1.下载并解压，添加服务定义

`vi /usr/lib/systemd/system/node-exporter.service`

```
[Unit]
Description=Node Exporter

[Service]
User=node_exporter
EnvironmentFile=/etc/sysconfig/node_exporter
ExecStart=/usr/sbin/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target
```

2.添加用户

```
 groupadd node_exporter
 
 useradd -g node_exporter -s /sbin/nologin node_exporter
 
```

3.` vi /etc/sysconfig/node_exporter`

```
OPTIONS="--collector.textfile.directory /var/lib/node_exporter/textfile_collector"
```

4.解压后的程序文件拷贝到`/usr/sbin/`

5.建个文件夹 `mkdir -p /var/lib/node_exporter/textfile_collector`

