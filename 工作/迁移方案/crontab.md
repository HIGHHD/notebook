

```
0 0 * * *  date >> /home/crontablogs/hurricane-ldap.log && curl 'http://172.21.199.1:9967/ldap/v1/sync/' >> /home/crontablogs/hurricane-ldap.log && echo -e "\n" >> /home/crontablogs/hurricane-ldap.log
```

