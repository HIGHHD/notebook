 为执行沪深交易所关于可转债高频交易监控的要求，拟在报表中心新增2个项目：历史可转债高频交易统计、当日可转债高频交易统计，使用部门为运营管理中心综合管理部。sql语句如附件，查询集中交易采集数据库



历史可转债高频交易统计 http://192.168.1.28/datamanage/APPS/48/156/SQL

```sql
select khh,sbrq,count(*) as c from 
(select khh,sbrq,sbsj,count(*) from datacenter.twtls where wtrq > to_char(sysdate-90,'yyyymmdd') and 
 jys='SH' and zqlb='Z5' and sbjg not in (8,9) and sbsj>'09:14:59' group by  khh,sbrq,sbsj 
having count(*)>10 order by count(*) desc)
group by khh,sbrq
```

当日可转债高频交易统计 http://192.168.1.28/datamanage/APPS/48/164/SQL

```sql
select khh,sbrq,count(*) as c from 
(select khh,sbrq,sbsj,count(*) from securities.tdrwt where jys='SH' and zqlb='Z5' and sbjg not in (8,9) and sbsj>'09:14:59' group by  khh,sbrq,sbsj 
having count(*)>10 order by count(*) desc)
group by khh,sbrq
```