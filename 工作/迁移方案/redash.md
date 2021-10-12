```
docker save 192.168.202.69:5001/redash:myv9 > redash-myv9.tar
docker load -i redash-myv9.tar

docker volume create redash_app
docker network create -d bridge bridge_net_0

docker volume inspect redash_app //查询实际位置
cd 实际位置 /home/docker/data/volumes/redash_app/_data

scp -r redash_app/_data/* root@192.168.1.166:/home/docker/data/volumes/redash_app/_data

scp -r redis_data/_data/* root@192.168.1.166:/home/docker/data/volumes/redash_redis/_data

scp -r postgres_data/_data/* root@192.168.1.166:/home/docker/data/volumes/redash_postgres/_data
```



```
version: '3'
x-redash-service: &redash-service
  image: 192.168.202.69:5001/redash:myv9
  env_file: env
  restart: always
  deploy:
    resources:
      limits:
        memory: 1G
      reservations:
        memory: 256M
  volumes:
    - redash_app:/app
  networks:
    - bridge_net_0
volumes:
  redash_app:
    external: true
networks:
  bridge_net_0:
    external: true
services:
  server:
    <<: *redash-service
    container_name: redash_server
    command: server
    ports:
      - "5000:5000"
    environment:
      REDASH_WEB_WORKERS: 4
  scheduler:
    <<: *redash-service
    container_name: redash_scheduler
    command: scheduler
    environment:
      QUEUES: "celery"
      WORKERS_COUNT: 1
  scheduled_worker:
    <<: *redash-service
    container_name: redash_scheduled_worker
    command: worker
    environment:
      QUEUES: "scheduled_queries,schemas"
      WORKERS_COUNT: 1
  adhoc_worker:
    <<: *redash-service
    container_name: redash_adhoc_worker
    command: worker
    environment:
      QUEUES: "queries"
      WORKERS_COUNT: 2
```

```
REDASH_DATABASE_URL=postgresql://redash:redash@postgres:5432/redash
REDASH_LOG_LEVEL=INFO
REDASH_REDIS_URL=redis://redis:6379/0
REDASH_MAIL_SERVER=192.168.1.206
REDASH_MAIL_PORT=25
REDASH_MAIL_USERNAME=niusiyuansc
REDASH_MAIL_PASSWORD=niuSiyuan1992
REDASH_MAIL_DEFAULT_SENDER=niusiyuansc@sczq.com.cn
REDASH_RATELIMIT_ENABLED=false
REDASH_ENFORCE_PRIVATE_IP_BLOCK=false
REDASH_ALLOW_SCRIPTS_IN_USER_INPUT=true
REDASH_LDAP_LOGIN_ENABLED=true
REDASH_LDAP_URL=ldap://192.168.1.1:389
REDASH_LDAP_BIND_DN='administrator@sc.local'
REDASH_LDAP_BIND_DN_PASSWORD='sczq29B4FH-M'
REDASH_LDAP_SEARCH_DN='OU=首创证券,DC=sc,DC=local'
REDASH_LDAP_SEARCH_TEMPLATE='(sAMAccountName=%(username)s)'
```

