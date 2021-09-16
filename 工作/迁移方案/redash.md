```
docker save 192.168.202.69:5001/redash:myv9 > redash-myv9.tar
docker load -i redash-myv9.tar

docker volume create redash_app
docker volume create redash_redis
docker volume create redash_postgres
docker network create -d bridge bridge_net_0

docker volume inspect redash_app //查询实际位置
cd 实际位置 /home/docker/data/volumes/redash_app/_data

scp -r redash_app/_data/* root@192.168.1.166:/home/docker/data/volumes/redash_app/_data

scp -r redis_data/_data/* root@192.168.1.166:/home/docker/data/volumes/redash_redis/_data

scp -r postgres_data/_data/* root@192.168.1.166:/home/docker/data/volumes/redash_postgres/_data
```

```
version: '2'
x-redash-service: &redash-service
  image: 192.168.202.69:5001/redash:myv9
  env_file: /docker/redash/env
  restart: always
  volumes:
    - redash_app:/app
  networks:
    bridge_net_0:
      aliases:
        - redash_net
volumes:
  redash_app:
    external: true
  redash_redis:
    external: true
  redash_postgres:
    external: true
networks:
  bridge_net_0:
    external: true
services:
  redis:
    image: redis:5.0.9
    container_name: redash_redis_5
    restart: always
    networks:
      bridge_net_0:
        aliases:
          - redash_redis_net
    volumes:
      - redash_redis:/data
  postgres:
    image: postgres:9.6.19
    container_name: redash_postgres_9_6
    restart: always
    environment:
      - POSTGRES_PASSWORD=job123x123!
    networks:
      bridge_net_0:
        aliases:
          - redash_postgres_net
    volumes:
      - redash_postgres:/var/lib/postgresql/data
  server:
    <<: *redash-service
    command: server
    ports:
      - "5000:5000"
    environment:
      REDASH_WEB_WORKERS: 4
  scheduler:
    <<: *redash-service
    command: scheduler
    environment:
      QUEUES: "celery"
      WORKERS_COUNT: 1
  scheduled_worker:
    <<: *redash-service
    command: worker
    environment:
      QUEUES: "scheduled_queries,schemas"
      WORKERS_COUNT: 1
  adhoc_worker:
    <<: *redash-service
    command: worker
    environment:
      QUEUES: "queries"
      WORKERS_COUNT: 2
```

```
REDASH_DATABASE_URL=postgresql://redash:redash@redash_postgres_net:5432/redash
REDASH_LOG_LEVEL=INFO
REDASH_REDIS_URL=redis://redash_redis_net:6379/0
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
REDASH_LDAP_BIND_DN='niusiyuansc@sc.local'
REDASH_LDAP_BIND_DN_PASSWORD='niuSiyuan1992'
REDASH_LDAP_SEARCH_DN='OU=首创证券,DC=sc,DC=local'
REDASH_LDAP_SEARCH_TEMPLATE='(sAMAccountName=%(username)s)'
```

