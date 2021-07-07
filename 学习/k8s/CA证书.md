## 根证书与证书

```text
通常我们配置https服务时需要到"权威机构"(CA)申请证书。过程是这样的：
1.网站创建一个密钥对，提供公钥和组织以及个人信息给权威机构
2.权威机构颁发证书
3.浏览网页的朋友利用权威机构的根证书公钥解密签名，对比摘要，确定合法性
4.客户端验证域名信息有效时间等（浏览器基本都内置各大权威机构的CA公钥）

这个证书包含如下内容：
1.申请者公钥
2.申请者组织和个人信息
3.签发机构CA信息，有效时间，序列号等
4.以上信息的签名

根证书又名自签名证书，也就是自己给自己颁发的证书。CA(Certificate Authority)被称为证书授权中心，
k8s中的ca证书就是根证书。

密钥对：sa.key sa.pub  根证书：ca.crt etcd/ca.crt  私钥:ca.key 等 其它证书

生成CA证书和私钥
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
ls | grep ca
ca-config.json
ca.csr
ca-csr.json
ca-key.pem
ca.pem
其中ca-key.pem是ca的私钥，ca.csr是一个签署请求，ca.pem是CA证书，是后面kubernetes组件会用到的RootCA。

#Pod中的容器访问API Server(如dashboard容器 访问API Server) 因为Pod的创建、销毁是动态的，所以要为它
手动生成证书就不可行了。K8s使用了Service Account解决Pod 访问API Server的认证问题
默认情况下，每个 namespace 都会有一个 ServiceAccount，如果 Pod 在创建时没有指定 ServiceAccount
就会使用 Pod 所属的 namespace 的 ServiceAccount,默认值/run/secrets/kubernates.io/serviceaccount/
#test 随便查看kube-system命名空间下的pod
  kubectl get pod -n kube-system
  kubectl exec  kube-proxy-cmzp6 -n=kube-system -it -- /bin/sh #进入容器
  cd /run/secrets/kubernates.io/serviceaccount/
  ls #里面有ca.crt(根的证书)   namespace  token 3个文件
  #token是使用 API Server 私钥签名的 JWT（json web token）。用于访问API Server时，Server端认证
  #ca.crt，根证书(是k8s中私有的)。用于Client端验证API Server发送的证书
  #namespace, 标识这个service-account-token的作用域名空间

service Account密钥对 sa.key sa.pub
提供给 kube-controller-manager使用，kube-controller-manager通过 sa.key 对 token 进行签名,
master 节点通过公钥 sa.pub 进行签名的验证 如 kube-proxy 是以 pod 形式运行的, 在 pod 中, 
直接使用 service account 与 kube-apiserver 进行认证, 此时就不需要再单独为 kube-proxy 创建证书了,
会直接使用token校验。

总结：公钥和私钥是成对的，它们互相解密。
      公钥加密，私钥解密。
      私钥数字签名，公钥验证。
一、公钥加密  假设一下，我找了两个数字，一个是1，一个是2 我喜欢2这个数字，就保留起来，
不告诉你们(私钥），然后我告诉大家，1是我的公钥。

我有一个文件，不能让别人看，我就用1加密了。别人找到了这个文件，但是他不知道2就是解密的私钥啊，
所以他解不开，只有我可以用 数字2，就是我的私钥，来解密。这样我就可以保护数据了。
我的好朋友x用我的公钥1加密了字符a，加密后成了b，放在网上。别人偷到了这个文件，但是别人解不开，
因为别人不知道2就是我的私钥， 只有我才能解密，解密后就得到a。这样，我们就可以传送加密的数据了。

 
二、私钥签名 如果我用私钥加密一段数据（当然只有我可以用私钥加密，因为只有我知道2是我的私钥），
结果所有的人都看到我的内容了，因为他们都知 道我的公钥是1，那么这种加密有什么用处呢？

假如我的好朋友x说有人冒充我给他发信。怎么办呢？我把我要发的信，内容是c，用我的私钥2，加密，
加密后的内容是d，发给x，再告诉他 解密看是不是c。他用我的公钥1解密，发现果然是c。 这个时候，
他会想到，能够用我的公钥解密的数据，必然是用我的私钥加的密。只有我知道我的私钥，
因此他就可以确认确实是我发的东西。 这样我们就能确认发送方身份了。这个过程叫做数字签名。
用私钥来加密数据，用途就是数字签名。
```

## k8s涉及的证书

```text
[root@k8s-master01 ~]# cd /etc/kubernetes/pki
[root@k8s-master01 pki]# tree
.
├── apiserver.crt
├── apiserver-etcd-client.crt
├── apiserver-etcd-client.key
├── apiserver.key
├── apiserver-kubelet-client.crt
├── apiserver-kubelet-client.key
├── ca.crt
├── ca.key
├── etcd
│   ├── ca.crt
│   ├── ca.key
│   ├── healthcheck-client.crt
│   ├── healthcheck-client.key
│   ├── peer.crt
│   ├── peer.key
│   ├── server.crt
│   └── server.key
├── front-proxy-ca.crt
├── front-proxy-ca.key
├── front-proxy-client.crt
├── front-proxy-client.key
├── sa.key
└── sa.pub

1 directory, 22 files

k8s集群一共有多少证书：
先从Etcd算起：
1、Etcd对外提供服务，要有一套etcd server证书
2、Etcd各节点之间进行通信，要有一套etcd peer证书
3、Kube-APIserver访问Etcd，要有一套etcd client证书

再算kubernetes：
4、Kube-APIserver对外提供服务，要有一套kube-apiserver server证书
5、kube-scheduler、kube-controller-manager、kube-proxy、kubelet和其他可能用到的组件，
   需要访问kube-APIserver，要有一套kube-APIserver client证书
6、kube-controller-manager要生成服务的service account，要有一对用来签署service account的证书(CA证书)
7、kubelet对外提供服务，要有一套kubelet server证书
8、kube-APIserver需要访问kubelet，要有一套kubelet client证书
```

