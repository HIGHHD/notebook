## 生命周期

**一、vue的生命周期是什么**

  vue每个组件都是独立的，每个组件都有一个属于它的生命周期，从一个组件**创建、数据初始化、挂载、更新、销毁**，这就是一个组件所谓的生命周期。在组件中具体的方法有:

  beforeCreate

  created

  beforeMount

  mounted

  (

​     beforeUpdate

​     updated

   )

  beforeDestroy

  destroyed

![](./生命周期.webp)

从第一二点可知道data的初始化是在created时已经完成数据观测(data observer)，并且诸如methods、computed属性 props等已经初始化；那问题来了，

data props computed watch methods他们之间的生成顺序是什么呢？

**props => methods =>data => computed => watch**;

 往往我们在开发项目时都经常用到 $refs 来直接访问子组件的方法，但是这样调用的时候可能会导致数据的延迟滞后的问题，则会出现bug。

解决方法则是推荐采取**异步回调**的方法，然后传参进去，严格遵守vue的生命周期就可以解决 推荐 es6 的promise。

数据请求一般在`created`生命周期钩子里做，因为data已经初始化、dom还没有挂载

