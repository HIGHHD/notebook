备份与还原mysql 数据库的常用命令。--all-databases 导出全部数据库| gzip > xxx.sql.gzgzip < xxx.sql.gz | 压缩导入导出https://blog.csdn.net/plfplc/article/details/80704018
https://www.cnblogs.com/nancyzhu/p/8511389.html
https://www.cnblogs.com/minseo/p/10282031.html

使用 PV 工具来监测进度
导入：
pv manman.sql | mysql -u root -p manman

```
 mysql -uroot -p123456 < runoob.sql
```

导出：
mysqldump -u manman -p manman | pv > manman.sql

编译源码方法
https://blog.csdn.net/weixin_30856965/article/details/96064795?depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-1&utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-1



MySQLdump参数
https://www.cnblogs.com/cqliyongqiang/p/9542386.html

--single-transaction
该选项在导出数据之前提交一个BEGIN SQL语句，BEGIN 不会阻塞任何应用程序且能保证导出时数据库的一致性状态。它只适用于多版本存储引擎，仅InnoDB。本选项和--lock-tables 选项是互斥的，因为LOCK  TABLES 会使任何挂起的事务隐含提交。要想导出大表的话，应结合使用--quick 选项。
mysqldump  -uroot -p --host=localhost --all-databases --single-transaction

--flush-logs
开始导出之前刷新日志。
请注意：假如一次导出多个数据库(使用选项--databases或者--all-databases)，将会逐个数据库刷新日志。除使用--lock-all-tables或者--master-data外。在这种情况下，日志将会被刷新一次，相应的所以表同时被锁定。因此，如果打算同时导出和刷新日志应该使用--lock-all-tables 或者--master-data 和--flush-logs。
mysqldump  -uroot -p --all-databases --flush-logs

--extended-insert,  -e
使用具有多个VALUES列的INSERT语法。这样使导出文件更小，并加速导入时的速度。默认为打开状态，使用--skip-extended-insert取消选项。
mysqldump  -uroot -p --all-databases
mysqldump  -uroot -p --all-databases--skip-extended-insert   (取消选项)

-c 参数，这样在生成 INSERT 语句的时候就有了字段名
不使用 -c 参数生成的语句如下：
INSERT INTO table1 VALUES (1,2,3)
而使用了 -c 参数后，语句变成
INSERT INTO table1(f1,f2,f3) VALUES(1,2,3)

-t
只生成插入数据的语句