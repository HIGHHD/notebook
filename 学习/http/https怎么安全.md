https是一个老生常谈的话题了，也是面试过程种经常会问到的一个问题，但当问到https为什么安全的时候，很多人的回答就是简单的回一句：因为它加密了！然后就没然后了！他也相当于啥都没回答出来！

大家都知道，http是明文传输，但是也有不少人这样想：虽然是明文传输，但我也没遇到什么不安全的问题呀，所以我也没必要搞https！

我只能给出以下几点解释：

> 你很幸运，没被盯上 。
> 你的网站没啥流量，搞你没啥价值。
> 你的账号密码等隐私信息已经被窃取，而你依然浑然不知。

## https为什么就安全了？他是怎么保证安全的？ 

想到安全，大家首先会想到，那就加密呗！所以引来第一个问题，如何加密？

在介绍如何加密问题前，先简单介绍一下加密的大致种类。

### 加密的大致种类：

1、不可逆加密。比如 MD5、SHA、HMAC

> 典型用途：
> 密码总不能明文存到数据库吧，所以一般加密存起来，只要用户的输入经过同样的加密算法 对比一下就知道密码是否正确了，所以没必要可逆。

2、可逆加密。

- 对称加密。比如：AES、DES、3DES、IDEA、RC4、RC5、RC6

> 典型用途： 
> 用同一个密码加密和解密，太常见了，我用密码加密文件发给你，你只能用我的密码才能解开。

- 非对称加密（就是公私钥）。比如：RSA、DSA、ECC

典型用途： 

1. 加密（保证数据安全性）使用公钥加密，需使用私钥解密。 
2. 认证（用于身份判断）使用私钥签名，需使用公钥验证签名。

### 介绍完加密种类，接下来说说如何加密 

#### 用不可逆加密可行吗？ 

首先不可逆加密的是不是可以直接排除了，不知道为啥的，可以想一想自己的目的是什么哈。

#### 用对称加密可行吗？ 

如果通信双方都各自持有同一个密钥，且没有别人知道，这两方的通信安全当然是可以被保证的,然而最大的问题就是这个密钥怎么让传输的双方知晓，同时不被别人知道,想一想：是不是不管怎么传，中间都有可能被截获，密钥都被截获了，其他的安全是不是也就无从谈起了。看来纯粹的对称加密不能解决http的安全问题。

#### 用非对称加密（rsa）可行吗？ 

试想一下：如果服务器生成公私钥，然后把公钥明文给客户端（有问题，下面说），那客户端以后传数据用公钥加密，服务端用私钥解密就行了，这貌似能保证浏览器到服务端的通道是安全的，那服务端到浏览器的通道如何保证安全呢？

那既然一对公私钥能保证，那如果浏览器本身也生成一对公私钥匙，然后把公钥明文发给服务端，抛开明文传递公钥的问题，那以后是不是可以安全通信了，的确可以！但https本身却不是这样做的，最主要的原因是非对称加密非常耗时，特别是加密解密一些较大数据的时候有些力不从心，当然还有其他原因。既然非对称加密非常耗时，那只能再考虑对称加密了。

#### 用非对称加密 + 对称加密可行吗？（行也得行，不行也得行，因为也没有其他方式了） 

上面提到浏览器拥有服务器的公钥，那浏览器生成一个密钥，用服务器的公钥加密传给服务端，然后服务端和浏览器以后拿这个密钥以对称加密的方式通信不就好了！完美！

所以接下来说一下上面遗留的一个问题：服务端的公钥是明文传过去的，有可能导致什么问题呢？

如果服务端在把明文公钥传递给浏览器的时候，被黑客截获下来，然后把数据包中的公钥替换成自己伪造的公钥（当然他自己有自己的私钥），浏览器本身是不知道公钥真假的，所以浏览器还是傻傻的按照之前的步骤，生成对称密钥，然后用假的公钥加密传递给服务端，这个时候，黑客截获到报文，然后用自己的私钥解密，拿到其中的对称密钥，然后再传给服务端，就这样神不知鬼不觉的，对称密钥被黑客截取，那以后的通信其实就是也就全都暴露给黑客了。

这也不行，那也不行，到底咋办？

淡定的考虑一下，上面的流程到底哪里存在问题，以致使黑客可以任意冒充服务端的公钥！

其实根本原因就是浏览器无法确认自己收到的公钥是不是网站自己的。

#### 如何保证浏览器收到的公钥一定是该网站的公钥 

现实生活中，如果想证明某身份证号一定是小明的，怎么办？看身份证。这里国家机构起到了“公信”的作用，身份证是由它颁发的，它本身的权威可以对一个人的身份信息作出证明。互联网中能不能搞这么个公信机构呢？给网站颁发一个“身份证”？当然可以，这就是平时经常说的数字证书。

#### 什么是数字证书?证书都包含什么? 

身份证之所以可信，是因为背后是国家，那数字证书如何才可信呢？这个时候找CA（Certificate Authority）机构。办身份证需要填写自己的各种信息，去CA机构申请证书需要什么呢？至少应该有以下几项吧：

1. 网站域名 

2. 证书持有者 

3. 证书有效期 

4. 证书颁发机构 

5. 服务器公钥（最主要）


接下来要说的签名时用的hash算法

那证书如何安全的送达给浏览器，如何防止被篡改呢？给证书盖个章（防伪标记）不就好了？这就又引出另外一个概念：数字签名。

#### 什么是数字签名？签名的过程是什么 

签名的过程其实也很简单：

> 1、CA机构拥有非对称加密的私钥和公钥。
> 2、CA对证书明文信息进行hash。
> 3、对hash后的值用私钥加密，得到数字签名。

所以呢，总结一下：CA机构颁发的证书包含（证书内容的明文+签名）。

#### 浏览器收到服务下发的证书之后，拿到证书明文和签名，怎么验证是否篡改了呢？ 

大家知道，私钥签名，公钥验签。证书里面的签名是CA机构用私钥签名的，所以我只要用CA机构的公钥验证一下签名不就好了，怎么验证呢？

还记得证书里面的明文包含什么吧，不记得的话看看上面的内容。

> 1、拿到证书里面明文的hash算法并对明文内容进行hash运算，得到A 。
> 2、用CA的公钥解密签名得到B 。
> 3、比较A 和 B，如果相等，说明没有被篡改，否则浏览器提示证书不可信。

#### 有没有发现一个问题？CA的公钥从哪里获取呢？ 

这个简单，CA权威机构本来也没多少个，所以，浏览器内部都内置了各大CA机构的公钥信息。

#### 简单总结一下：

1. 如果证书被篡改，浏览器就提示不可信，终止通信，如果验证通过，说明公钥没问题，一定没被篡改。
2. 公钥没被篡改，那浏览器生成的对称加密用的密钥用公钥加密发送给服务端，也只有服务端的私钥能解开，所以保证了 对称密钥不可能被截获，对称密钥没被截获，那双方的通信就一定是安全的。
3. 黑客依然可以截获数据包，但是全都是经过对称加密的密钥加密的，他也可以篡改，只是没有任何意义了,黑客也不会做吃力不讨好的事了。

**浏览器不能验证自签名机构的证书是否被篡改，除非将自签根证书添加到浏览器“受信任的根证书颁发机构”中**

**客户端和CA的交互，只存在于验证证书是否被吊销**

