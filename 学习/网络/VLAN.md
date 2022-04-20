VLAN（Virtual Local Area Network）的中文名为"虚拟局域网"。

**VLAN是二层技术，要实现不同VLAN互通，就需要三层路由功能**

虚拟局域网（VLAN）是一组逻辑上的设备和用户，这些设备和用户并不受物理位置的限制，可以根据功能、部门及应用等因素将它们组织起来，相互之间的通信就好像它们在[同一个网段](https://baike.baidu.com/item/同一个网段/10612240)中一样，由此得名虚拟局域网，由于交换机端口有两种VLAN属性，其一是VLANID，其二是VLANTAG，分别对应VLAN对数据包设置VLAN标签和允许通过的VLANTAG（标签）数据包，不同VLANID端口，可以通过相互允许VLANTAG，构建VLAN。VLAN是一种比较新的技术，工作在[OSI参考模型](https://baike.baidu.com/item/OSI参考模型)的第2层和第3层，一个VLAN不一定是一个[广播域](https://baike.baidu.com/item/广播域/5293530)，VLAN之间的通信并不一定需要路由网关，其本身可以通过对VLANTAG的相互允许，组成不同访问控制属性的VLAN，当然也可以通过第3层的[路由器](https://baike.baidu.com/item/路由器/108294)来完成的，但是，通过VLANID和VLANTAG的允许，VLAN可以为几乎局域网内任何信息集成系统架构逻辑拓扑和访问控制，并且与其它共享物理网路链路的信息系统实现相互间无扰共享。VLAN可以为信息业务和子业务、以及信息业务间提供一个相符合业务结构的虚拟网络拓扑架构并实现访问控制功能。与传统的[局域网技术](https://baike.baidu.com/item/局域网技术/2597024)相比较，[VLAN技术](https://baike.baidu.com/item/VLAN技术/10648597)更加灵活，它具有以下优点： 网络设备的移动、添加和修改的管理开销减少；可以控制[广播](https://baike.baidu.com/item/广播/656406)活动；可提高[网络](https://baike.baidu.com/item/网络/143243)的安全性。

VLAN（Virtual Local Area Network，虚拟局域网）的目的非常的多。通过认识VLAN的本质，将可以了解到其用处究竟在哪些地方。

1、要知道192.168.1.2/30和192.168.2.6/30都属于不同的[网段](https://baike.baidu.com/item/网段)，都必须要通过[路由器](https://baike.baidu.com/item/路由器)才能进行访问，凡是不同网段间要互相访问，都必须通过路由器。

2、VLAN本质就是指一个[网段](https://baike.baidu.com/item/网段)，之所以叫做虚拟的局域网，是因为它是在虚拟的[路由器](https://baike.baidu.com/item/路由器)的接口下创建的网段。

下面，给予说明。比如一个[路由器](https://baike.baidu.com/item/路由器)只有一个用于[终端](https://baike.baidu.com/item/终端)连接的端口（当然这种情况基本不可能发生，只不过简化举例），这个端口被分配了192.168.1.1/24的地址。然而由于公司有两个部门，一个销售部，一个企划部，每个部门要求单独成为一个子网，有单独的服务器。那么当然可以划分为192.168.1.0--127/25、192.168.1.128--255/25。但是[路由器](https://baike.baidu.com/item/路由器)的物理端口只应该可以分配一个IP地址，那怎样来区分不同[网段](https://baike.baidu.com/item/网段)了？这就可以在这个物理端口下，创建两个子接口---[逻辑接口](https://baike.baidu.com/item/逻辑接口)实现。

比如[逻辑接口](https://baike.baidu.com/item/逻辑接口)F0/0.1就分配IP地址192.168.1.1/25，用于销售部，而F0/0.2就分配IP地址192.168.1.129/25，用于企划部。这样就等于用一个物理端口却实现了两个[逻辑接口](https://baike.baidu.com/item/逻辑接口)的功能，这样就将原本只能划分一个[网段](https://baike.baidu.com/item/网段)的情形，扩展到了可以划分2个或者更多个网段的情形。这些[网段](https://baike.baidu.com/item/网段)因为是在[逻辑接口](https://baike.baidu.com/item/逻辑接口)下创建的，所以称之为虚拟局域网VLAN。这是在[路由器](https://baike.baidu.com/item/路由器)的层次上阐述了VLAN的目的。

3、将在[交换机](https://baike.baidu.com/item/交换机)的层次上阐述VLAN的目的。

在现实中，由于很多原因必须划分出不同[网段](https://baike.baidu.com/item/网段)。比如就简单的只有销售部和企划部两个[网段](https://baike.baidu.com/item/网段)。那么可以简单的将销售部全部接入一个交换机，然后[接入路由器](https://baike.baidu.com/item/接入路由器)的一个端口，把企划部全部接入一个[交换机](https://baike.baidu.com/item/交换机)，然后接入一个[路由器](https://baike.baidu.com/item/路由器)端口。这种情况是LAN。然而正如上面所说，如果[路由器](https://baike.baidu.com/item/路由器)就一个用于终端的接口，那么这两个[交换机](https://baike.baidu.com/item/交换机)就必须接入这同一个[路由器](https://baike.baidu.com/item/路由器)的接口，这个时候，如果还想保持原来的[网段](https://baike.baidu.com/item/网段)的划分，那么就必须使用路由器的[子接口](https://baike.baidu.com/item/子接口)，创建VLAN。

同样，比如两个[交换机](https://baike.baidu.com/item/交换机)，如果你想要每个交换机上的端口都分别属于不同的[网段](https://baike.baidu.com/item/网段)，那么你有几个网段，就提供几个[路由器](https://baike.baidu.com/item/路由器)的接口，这个时候，虽然在路由器的物理接口上可以[定义](https://baike.baidu.com/item/定义)这个接口可以连接哪个网段，但是在交换机的层次上，它并不能区分哪个端口属于哪个网段，那么唯一实现能区分的方法，就是划分VLAN，使用了VLAN就能区分出某个交换机端口的终端是属于哪个网段的。

综上，当一个[交换机](https://baike.baidu.com/item/交换机)上的所有端口中有至少一个端口属于不同[网段](https://baike.baidu.com/item/网段)的时候，当[路由器](https://baike.baidu.com/item/路由器)的一个物理端口要连接2个或者以上的网段的时候，就是VLAN发挥作用的时候，这就是VLAN的目的。



### 为什么使用VLAN

可以有效控制网络风暴，节约资源（设备、流量）

未分割VLAN时将会发生什么？如果仅有一个广播域，有可能会影响到网络整体的传输性能。在基于以太网的通信中，必须在数据帧中指定目标MAC地址才能正常通信，因此计算机必须先广播“ARP请求(ARP Request)信息”，来尝试获取另一计算机的MAC地址。交换机收到广播帧(ARP请求)后，会将它转发给除接收端口外的其他所有端口，也就是泛滥了。接着，网络上其他交换机收到广播帧后也会泛滥。最终ARP请求会被转发到同一网络中的所有客户机上，这也就是网络风暴。

我们分析下，这个计算A的ARP请求原本是为了获得计算机B的MAC地址而发出的。也就是说：只要计算机B能收到就万事大吉了。可是事实上，数据帧却传遍整个网络，导致所有的计算机都收到了它。如此一来，一方面广播信息消耗了网络整体的带宽，另一方面，收到广播信息的计算机还要消耗一部分CPU时间来对它进行处理。造成了网络带宽和CPU运算能力的大量无谓消耗，可能会造成网络瘫痪。

