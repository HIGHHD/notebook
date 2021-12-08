rsync 和 rsyncssh

rsyncssh使用 ssh 进行传输，在配置上不使用默认的rysnc目标，需要将host和targetdir分开写



使用rsyncssh

```
settings{
    logfile = "/var/log/lsyncd/lsyncd.log",
    statusFile = "/var/log/lsyncd/lsyncd.status",
	inotifyMode = "CloseWrite or Modify",
	nodaemon = false,
	statusInterval = 3,
	maxDelays = 1
}
servers = {
	"root@172.21.194.42",
}
--同步规则
for _, server in ipairs(servers) do    --迭代servers
	sync{
		default.rsyncssh,
		source = "/home/www",
		host = server,
		targetdir="/home/www",
		exclude = {"Data/*" },
		delete = true,
		rsync = {
			bwlimit=500,
			binary = "/usr/bin/rsync",
			archive = true,
			compress = true,
			verbose = true,
			perms = true,
		},
		ssh = {
			port = 22
		}
	}
end
```

使用rsync

```
settings{
    logfile = "/var/log/lsyncd/lsyncd.log",
    statusFile = "/var/log/lsyncd/lsyncd.status",
	inotifyMode = "CloseWrite or Modify",
	nodaemon = false,
	statusInterval = 3,
	maxDelays = 1
}
servers = {
	"rsyncuser@172.21.194.42::web",
}
--同步规则
for _, server in ipairs(servers) do    --迭代servers
	sync{
		default.rsync,
		source = "/home/www",
		target = server,
		exclude = {"Data/*" },
		delete = true,
		rsync = {
			bwlimit=500,
			binary = "/usr/bin/rsync",
			archive = true,
			compress = true,
			verbose = true,
			perms = true,
			password_file = "/etc/rsyncd-key.passwd" -- 只有密码的key文件
		}
	}
end
```

