```
docker volume create redis_data && \
docker volume create postgres_data && \
docker volume create maria_data && \
docker volume create maria_conf
```

```
FROM mariadb:10.5

RUN echo "Asia/Shanghai" > /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

VOLUME ["/var/lib/mysql", "/etc/mysql"]

ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3306
CMD ["mysqld"]
```


```
version: '3'
volumes:
  redis_data:
    external: true
  postgres_data:
    external: true
  maria_data:
    external: true
  maria_conf:
    external: true
networks:
  bridge_net_0:
    external: true
services:
  redis:
    image: redis:5.0.9
    container_name: redis
    restart: always
    networks:
      - bridge_net_0
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
  postgres:
    image: postgres:9.6.19
    container_name: postgres
    restart: always
    environment:
      - POSTGRES_PASSWORD=job123x123!
    ports:
      - "5432:5432"
    networks:
      - bridge_net_0
    volumes:
      - postgres_data:/var/lib/postgresql/data
  mariadb:
    image: mariadb:10.5
    container_name: mariadb
    restart: always
    environment:
      - MARIADB_ROOT_PASSWORD=maria123!
    command:
      --character-set-server=utf8
      --collation-server=utf8_general_ci
      --explicit_defaults_for_timestamp=true
      --lower_case_table_names=1
      --max_allowed_packet=128M
    ports:
      - "3306:3306"
    networks:
      - bridge_net_0
    volumes:
      - maria_data:/var/lib/mysql
      - maria_conf:/etc/mysql
```

```

show tables from blizzard;
flush privileges;

```

