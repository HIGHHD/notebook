### 查看仓库和tag

```
Listing Repositories (link)
GET /v2/_catalog
Listing Image Tags (link)
GET /v2/<name>/tags/list
```

### api地址

https://docs.docker.com/registry/spec/api/#detail

### 垃圾回收

```
docker exec -it registry /bin/registry garbage-collect /etc/docker/registry/config.yml
然后
删除 /var/lib/registry/docker/registry/v2/repositories 不用的仓库目录
```

### 删除镜像

```
删除镜像只能用digest
通过
docker images --digests
或进入仓库查看
cat /var/lib/registry/docker/registry/v2/repositories/<name>/_manifests/tags/<tag>/current/link
或
GET http://172.21.199.1:5001/v2/<name>/manifests/<tag> 获取revision字段

执行
DELETE http://172.21.199.1:5001/v2/<name>/manifests/<digest>
```

