**js到底是什么类型语言**

JavaScript 代码需要在机器（node 或者浏览器）上安装一个工具（JS 引擎）才能执行。这是解释型语言需要的。编译型语言程序能够自由地直接运行。

变量提升不是代码修改。在这个过程中没有生成中间代码。变量提升只是 JS 解释器处理事情的方式。

JIT（just-in-time compilation 是唯一一点我们可以对 JavaScript 是否是一个解释型语言提出疑问的理由。但是 JIT 不是完整的编译器，它在执行前进行编译。而且 JIT 只是 Mozilla 和 Google 的开发人员为了提升浏览器性能才引入的。JavaScript 或 TC39 从来没有强制要求使用 JIT。

因此，虽然 JavaScript 执行时像是在编译或者像是一种编译和解释的混合，我仍然认为 JavaScript 是一个解释型语言或者是一个今天很多人说的混合型语言，而不是编译型语言。

**js编译原理**

JS编译分三个步骤，词法分析、语法分析以及代码生成，编译过程涉及三个角色，引擎、编译器和作用域。

编译过程涉及三个角色，引擎、编译器和作用域。

引擎是贯穿整个编译过程的，相当于主干。而编译器，主要是负责词法分析、语法分析与代码生成。作用域主要负责收集与维护标识符集合（应该就是我们声明的变量），并且控制当前代码对标识符的访问权限。先来看看词法分析、语法分析、代码生成的过程。

举个例子： 对于var a = 2;

词法分析： 编译器会把var a = 2;这个字符串拆分成词法单元，也就是var、a、=、2、;，词法生成器判断a是一个独立的词法单元还是其他词法单元的一部分，如果用的是有状态的解析规则，这个过程就是词法分析。

语法解析：将词法单元流（也就是[var,a,=,2,;]）转换成 由元素逐级嵌套的 代表了 程序语法结构的树，也就是抽象语法树（Abstract Syntax Tree），简称AST，这个过程是语法解析。

代码生成： 将AST转换成一组机器指令，用来创建一个叫做a的变量，包括分配内存等，并存储一个值在a中

整个流程： 首先，当**编译器**遇到var a的时候，**编译器**会去询问作用域是否已经有一个该名称的变量存在于同一个作用域的集合中。如果是，编译器会忽略该声明，继续进行编译；否则它会要求作用域在当前作用域的集合中声明

接下来**编译器会为引擎生成运行时所需要的代码**，这些代码被用来处理a=2这个赋值操作。**引擎**会先询问作用域，在当前作用域集是否存在a这个变量，如果是，引擎会直接使用这个变量，如果不是，就继续寻找

编译型和解释型语言最重要的区别是编译语言话很长的时间来准备执行。因为它需要对整个代码进行词法分析、做一些极致的优化等工作。另一方面解释型语言几乎在执行后一瞬间就开始，但是没有任何代码优化。所以每一条语句都是分开转换的，考虑下面这一段代码。 `for(i=0; i&lt;1000; i++){    sum += i; }` 在编译型语言中`sum += i`部分在循环运行时已经编译成了机器码，机器码将直接运行一千次。 但是在解释型语言中，他会在执行时将`sum += i`解释一千次。所以因为对相同的代码进行一千次转换会造成非常大的性能损耗。 这就是Google和Mozilla的开发人员将**JIT**加入JavaScript的原因。

下面是JavaScript处理声明语句的过程：

- 一旦 V8 引擎进入一个执行具体代码的执行上下文（函数），它就对代码进行词法分析或者分词。这意味着代码将被分割成像foo = 10这样的原子符号（atomic token）。
- 在对当前的整个作用域分析完成后，引擎将 token 解析翻译成一个AST（抽象语法树）。
- 引擎每次遇到声明语句，就会把声明传到作用域（scope）中创建一个绑定。每次声明都会为变量分配内存。只是分配内存，并不会修改源代码将变量声明语句提升。正如你所知道的，在JS中分配内存意味着将变量默认设为undefined。
- 在这之后，引擎每一次遇到赋值或者取值，都会通过作用域（scope）查找绑定。如果在当前作用域中没有查找到就接着向上级作用域查找直到找到为止。
- 接着引擎生成 CPU 可以执行的机器码。
- 最后， 代码执行完毕。

**AST**

recast、[抽象语法树](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/Parser_API#node_objects)

**事件循环机制、宏任务、微任务**

众所周知，JavaScript 是一门单线程语言，虽然在 html5 中提出了 Web-Worker ，但这并未改变 JavaScript 是单线程这一核心。可看[HTML规范中](https://www.w3.org/TR/html5/webappapis.html#event-loops)的这段话：

> To coordinate events, user interaction, scripts, rendering, networking, and so forth, user agents must use event loops as described in this section. There are two kinds of event loops: those for browsing contexts, and those for workers.

所有的任务可以分为同步任务和异步任务，同步任务，顾名思义，就是立即执行的任务，同步任务一般会直接进入到主线程中执行；而异步任务，就是异步执行的任务，比如ajax网络请求，setTimeout 定时函数等都属于异步任务，异步任务会通过任务队列( Event Queue )的机制来进行协调。具体的可以用下面的图来大致说明一下：

![](N:\Documents\notebook\题目\js-1.jpg)

同步和异步任务分别进入不同的执行环境，同步的进入主线程，即主执行栈，异步的进入 Event Queue 。主线程内的任务执行完毕为空，会去 Event Queue 读取对应的任务，推入主线程执行。 上述过程的不断重复就是我们说的 Event Loop (事件循环)。

在事件循环中，每进行一次循环操作称为tick，通过阅读规范可知，每一次 tick 的任务处理模型是比较复杂的，其关键的步骤可以总结如下：

1. 在此次 tick 中选择最先进入队列的任务( oldest task )，如果有则执行(一次)
2. 检查是否存在 Microtasks ，如果存在则不停地执行，直至清空Microtask Queue
3. 更新 render
4. 主线程重复执行上述步骤

可以用一张图来说明下流程：

![](N:\Documents\notebook\题目\js-2.jpg)

规范中规定，task分为两大类, 分别是 Macro Task （宏任务）和 Micro Task（微任务）, 并且每个宏任务结束后, 都要清空所有的微任务,这里的 Macro Task也是我们常说的 task ，有些文章并没有对其做区分，后面文章中所提及的task皆看做宏任务( macro task)。

(macro)task 主要包含：script( 整体代码)、setTimeout、setInterval、I/O、UI 交互事件、setImmediate(Node.js 环境)

microtask主要包含：Promise、MutaionObserver、process.nextTick(Node.js 环境)

setTimeout/Promise 等API便是任务源，而进入任务队列的是由他们指定的具体执行任务。来自不同任务源的任务会进入到不同的任务队列。其中 setTimeout 与 setInterval 是同源的。

```js
console.log('script start');

setTimeout(function() {
  console.log('setTimeout');
}, 0);

Promise.resolve().then(function() {
  console.log('promise1');
}).then(function() {
  console.log('promise2');
});

console.log('script end');
```

1. 整体 script 作为第一个宏任务进入主线程，遇到 console.log，输出 script start
2. 遇到 setTimeout，其回调函数被分发到宏任务 Event Queue 中
3. 遇到 Promise，其 then函数被分到到微任务 Event Queue 中,记为 then1，之后又遇到了 then 函数，将其分到微任务 Event Queue 中，记为 then2
4. 遇到 console.log，输出 script end

至此，Event Queue 中存在三个任务，如下表：

| 宏任务     | 微任务 |
| ---------- | ------ |
| setTimeout | then1  |
| -          | then2  |

1. 执行微任务，首先执行then1，输出 promise1, 然后执行 then2，输出 promise2，这样就清空了所有微任务
2. 执行 setTimeout 任务，输出 setTimeout 至此，输出的顺序是：script start, script end, promise1, promise2, setTimeout

```js
console.log('script start');

setTimeout(function() {
  console.log('timeout1');
}, 10);

new Promise(resolve => {
    console.log('promise1');
    resolve();
    setTimeout(() => console.log('timeout2'), 10);
}).then(function() {
    console.log('then1')
})

console.log('script end');
```

首先，事件循环从宏任务 (macrotask) 队列开始，最初始，宏任务队列中，只有一个 scrip t(整体代码)任务；当遇到任务源 (task source) 时，则会先分发任务到对应的任务队列中去。所以，就和上面例子类似，首先遇到了console.log，输出 script start； 接着往下走，遇到 setTimeout 任务源，将其分发到任务队列中去，记为 timeout1； 接着遇到 promise，new promise 中的代码立即执行，输出 promise1, 然后执行 resolve ,遇到 setTimeout ,将其分发到任务队列中去，记为 timemout2, 将其 then 分发到微任务队列中去，记为 then1； 接着遇到 console.log 代码，直接输出 script end 接着检查微任务队列，发现有个 then1 微任务，执行，输出then1 再检查微任务队列，发现已经清空，则开始检查宏任务队列，执行 timeout1,输出 timeout1； 接着执行 timeout2，输出 timeout2 至此，所有的都队列都已清空，执行完毕。其输出的顺序依次是：script start, promise1, script end, then1, timeout1, timeout2

![](N:\Documents\notebook\题目\js-3.jpg)

有个小 tip：从规范来看，microtask 优先于 task 执行，所以如果有需要优先执行的逻辑，放入microtask 队列会比 task 更早的被执行。

最后的最后，记住，*JavaScript 是一门单线程语言，异步操作都是放到事件循环队列里面，等待主执行栈来执行的，并没有专门的异步执行线程。。*

**node是单线程，为什么能处理高并发**

1. 每个Node.js进程只有一个主线程在执行程序代码，形成一个**执行栈**（**execution context stack**)。
2. 主线程之外，还维护了一个"**事件队列**"（Event queue）。当用户的网络请求或者其它的异步操作到来时，node都会把它放到Event Queue之中，此时并不会立即执行它，代码也不会被阻塞，继续往下走，直到主线程代码执行完毕。
3. 主线程代码执行完毕完成后，然后通过Event Loop，也就是**事件循环机制**，开始到Event Queue的开头取出第一个事件，从线程池中分配一个线程去执行这个事件，接下来继续取出第二个事件，再从**线程池**中分配一个线程去执行，然后第三个，第四个。主线程不断的检查事件队列中是否有未执行的事件，直到事件队列中所有事件都执行完了，此后每当有新的事件加入到事件队列中，都会通知主线程按顺序取出交EventLoop处理。当有事件执行完毕后，会通知主线程，主线程执行回调，线程归还给线程池。
4. 主线程不断重复上面的第三步。

单线程的好处：

- 多线程占用内存高
- 多线程间切换使得CPU开销大
- 多线程由内存同步开销
- 编写单线程程序简单
- 线程安全

单线程的劣势：

- CPU密集型任务占用CPU时间长（可通过cluster方式解决）
- 无法利用CPU的多核（可通过cluster方式解决）
- 单线程抛出异常使得程序停止（可通过try catch方式或自动重启机制解决）

**node事件循环机制**

> [Node.js 事件循环，定时器和 process.nextTick() | Node.js (nodejs.org)](https://nodejs.org/zh-cn/docs/guides/event-loop-timers-and-nexttick/)

**跨域的解决方式，cors、jsonp**

同源策略/SOP（Same origin policy）是一种约定，由Netscape公司1995年引入浏览器，它是浏览器最核心也最基本的安全功能，如果缺少了同源策略，浏览器很容易受到XSS、CSFR等攻击。所谓同源是指"协议+域名+端口"三者相同，即便两个不同的域名指向同一个ip地址，也非同源。同源策略是浏览器的安全策略，不是HTTP协议的一部分。

同源策略限制以下几种行为：

1. Cookie、LocalStorage 和 IndexDB 无法读取
2. DOM 和 Js对象无法获得
3. AJAX 请求不能发送

jsonp就是利用`<script>`标签没有跨域限制的“漏洞”，利用script标签的src属性

postMessage

跨域资源共享（CORS），前端一般不用设置（带cookie需要设置）、后端接口实现

nginx 跨域原理： 通过nginx配置一个代理服务器（域名与domain1相同，端口不同）做跳板机，反向代理访问domain2接口，并且可以顺便修改cookie中domain信息，方便当前域cookie写入，实现跨域登录。

浏览器将CORS请求分成两类：简单请求（simple request）和非简单请求（not-so-simple request）。

只要同时满足以下两大条件，就属于简单请求。

> （1) 请求方法是以下三种方法之一：
>
> - HEAD
> - GET
> - POST
>
> （2）HTTP的头信息不超出以下几种字段：
>
> - Accept
> - Accept-Language
> - Content-Language
> - Last-Event-ID
> - Content-Type：只限于三个值`application/x-www-form-urlencoded`、`multipart/form-data`、`text/plain`



**缓存机制，304、强缓存**



**web安全、xss，csrf**

xss全称跨站脚本攻击、csrf全称跨站请求伪造

大部分xss漏洞都是由于没有处理好用户的输入，导致恶意脚本在浏览器中执行，任何输入提交数据的地方都可能存在xss，处理用户输入，cookie设置httponly

csrf防范方法：验证 HTTP Referer 字段；在请求地址中添加 token 并验证；在 HTTP 头中自定义属性并验证



**node错误处理**

node是对错误处理要求比较高的语言，假如对错误处理没有到位可能会造成程序进程退出

> https://zhuanlan.zhihu.com/p/123857666
>
> 

**koa中间件机制、解决了什么问题、怎么实现**



**如何理解前后端分离**



**react ssr 实现难点、如何区分服务端环境还是客户端环境**



**多实例如何保存登录状态，也就是session如何存储**



**快应用和微信小程序底层机制区别**



**常用设计模式有哪些，具体应用场景是什么**



**数据库死锁如何解决**



**介绍消息队列以及应用**



**说说对MVVM的理解**

MVVM是Model-View-ViewModel的