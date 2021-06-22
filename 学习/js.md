> [JavaScript 教程 - 网道 (wangdoc.com)](https://wangdoc.com/javascript/)
>
> [ES6 入门教程 - ECMAScript 6入门 (ruanyifeng.com)](https://es6.ruanyifeng.com/#README)

### js到底是什么类型语言

JavaScript 代码需要在机器（node 或者浏览器）上安装一个工具（JS 引擎）才能执行。这是解释型语言需要的。编译型语言程序能够自由地直接运行。

变量提升不是代码修改。在这个过程中没有生成中间代码。变量提升只是 JS 解释器处理事情的方式。

JIT（just-in-time compilation 是唯一一点我们可以对 JavaScript 是否是一个解释型语言提出疑问的理由。但是 JIT 不是完整的编译器，它在执行前进行编译。而且 JIT 只是 Mozilla 和 Google 的开发人员为了提升浏览器性能才引入的。JavaScript 或 TC39 从来没有强制要求使用 JIT。

因此，虽然 JavaScript 执行时像是在编译或者像是一种编译和解释的混合，我仍然认为 JavaScript 是一个解释型语言或者是一个今天很多人说的混合型语言，而不是编译型语言。

### js编译原理

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

### AST

recast、[抽象语法树](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/Parser_API#node_objects)

### 事件循环机制、宏任务、微任务

众所周知，JavaScript 是一门单线程语言，虽然在 html5 中提出了 Web-Worker ，但这并未改变 JavaScript 是单线程这一核心。可看[HTML规范中](https://www.w3.org/TR/html5/webappapis.html#event-loops)的这段话：

> To coordinate events, user interaction, scripts, rendering, networking, and so forth, user agents must use event loops as described in this section. There are two kinds of event loops: those for browsing contexts, and those for workers.

所有的任务可以分为同步任务和异步任务，同步任务，顾名思义，就是立即执行的任务，同步任务一般会直接进入到主线程中执行；而异步任务，就是异步执行的任务，比如ajax网络请求，setTimeout 定时函数等都属于异步任务，异步任务会通过任务队列( Event Queue )的机制来进行协调。具体的可以用下面的图来大致说明一下：

![](.\js-1.jpg)

同步和异步任务分别进入不同的执行环境，同步的进入主线程，即主执行栈，异步的进入 Event Queue 。主线程内的任务执行完毕为空，会去 Event Queue 读取对应的任务，推入主线程执行。 上述过程的不断重复就是我们说的 Event Loop (事件循环)。

在事件循环中，每进行一次循环操作称为tick，通过阅读规范可知，每一次 tick 的任务处理模型是比较复杂的，其关键的步骤可以总结如下：

1. 在此次 tick 中选择最先进入队列的任务( oldest task )，如果有则执行(一次)
2. 检查是否存在 Microtasks ，如果存在则不停地执行，直至清空Microtask Queue
3. 更新 render
4. 主线程重复执行上述步骤

可以用一张图来说明下流程：

![](.\js-2.jpg)

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

![](.\js-3.jpg)

有个小 tip：从规范来看，microtask 优先于 task 执行，所以如果有需要优先执行的逻辑，放入microtask 队列会比 task 更早的被执行。

最后的最后，记住，*JavaScript 是一门单线程语言，异步操作都是放到事件循环队列里面，等待主执行栈来执行的，并没有专门的异步执行线程。。*

### node是单线程，为什么能处理高并发

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

### node事件循环机制

> [Node.js 事件循环，定时器和 process.nextTick() | Node.js (nodejs.org)](https://nodejs.org/zh-cn/docs/guides/event-loop-timers-and-nexttick/)

### 跨域的解决方式，cors、jsonp

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



### 缓存机制，304、强缓存

200强缓存、304协商缓存

![](.\js-4.png)
![](.\js-5.png)

### web安全、xss，csrf

xss全称跨站脚本攻击、csrf全称跨站请求伪造

大部分xss漏洞都是由于没有处理好用户的输入，导致恶意脚本在浏览器中执行，任何输入提交数据的地方都可能存在xss，处理用户输入，cookie设置httponly

csrf防范方法：验证 HTTP Referer 字段；在请求地址中添加 token 并验证；在 HTTP 头中自定义属性并验证



### node错误处理

node是对错误处理要求比较高的语言，假如对错误处理没有到位可能会造成程序进程退出

> https://zhuanlan.zhihu.com/p/123857666

### koa中间件机制、解决了什么问题、怎么实现

解决了express中，具有的回调陷阱问题，优化了开发体验。`KOA`中间件通过`async/await`来在不同中间件之间交换控制权，工作机制和**栈**结构非常相似

### 如何理解前后端分离

首先要明确前后端的界限，我认为，前端应该侧重于页面展示、路由跳转、数据渲染、用户交互、部分数据逻辑处理、前端缓存；后端侧重于数据存储、数据缓存、数据处理、接口实现、会话等，以前的前后端令人诟病的一点就是前后台代码绑定到极致，增加了再次开发的难度，增加了后台服务器压力，我理解的前后端分离就是，前后端应该专注于自己的长项，资源得到合理利用，既不是代码上的完全隔离也不是开发人员上的完全隔离

### react ssr 实现难点、如何区分服务端环境还是客户端环境



### 多实例如何保存登录状态，也就是session如何存储

session做标识，保证从哪来到哪去，有个缺点是，如果宕机，客户需要重新登录
集中存储会话

### 快应用和微信小程序底层机制区别

快应用比微信小程序更进一步的是，使用native渲染而不是webview渲染。
再加上硬件资源扶持，在体验上更上一层楼。
但不能用webview后，也有一些麻烦，就是可以用的api目前还比微信少很多。

### 常用设计模式有哪些，具体应用场景是什么



### 数据库死锁如何解决



### 介绍消息队列以及应用



### 说说对MVVM的理解

MVVM是Model-View-ViewModel的



### DOM事件传播

事件传播有三个阶段，

- 捕获阶段-事件从window开始，向下传播至目标元素，并经过途中每个元素
- 目标阶段-事件已到达目标元素
- 冒泡阶段-事件从目标元素冒泡，上升至window，并经过途中每个元素

事件的监听可以选择在捕获或冒泡阶段的任一元素上，event.target 指向事件的目标元素，即发生事件的元素或触发事件的元素，event.currentTarget是附加事件处理程序的元素。



### 关于var和let



### 关于AMD、CMD、CommonJS、ES6、UMD

AMD是RequireJS在推广过程中对模块定义的规范化，它是一个概念。RequireJS是这个概念的实现，是一个**依赖前置、异步定义**的框架

CMD是SeaJS在推广过程中的对模块定义的规范化，是一个同步模块的定义，是SeaJS的一个标准，是一个**依赖就近**的框架

AMD都是用`define()`定义，使用`require`加载，用于前端浏览器

CommonJS是nodejs专用的模块格式，前端浏览器不能使用，使用`module.exports`定义，使用`require`引入

ES6（简称ESM）和CommonJS（简称CJS）模块是js语言两种格式的模块，着来拿工资模块不兼容

语法上面，CommonJS 模块使用`require()`加载和`module.exports`输出，ES6 模块使用`import`和`export`。

用法上面，`require()`是同步加载，后面的代码必须等待这个命令执行完，才会执行。`import`命令则是异步加载，或者更准确地说，ES6 模块有一个独立的静态解析阶段，依赖关系的分析是在那个阶段完成的，最底层的模块第一个执行。

Node.js 要求 ES6 模块采用`.mjs`后缀文件名。也就是说，只要脚本文件里面使用`import`或者`export`命令，那么就必须采用`.mjs`后缀名。Node.js 遇到`.mjs`文件，就认为它是 ES6 模块，默认启用严格模式，不必在每个模块文件顶部指定`"use strict"`

如果不希望将后缀名改成`.mjs`，可以在项目的`package.json`文件中，指定`type`字段为`module`。

> ```javascript
> {
>    "type": "module"
> }
> ```

一旦设置了以后，该目录里面的 JS 脚本，就被解释用 ES6 模块。

> ```bash
> # 解释成 ES6 模块
> $ node my-app.js
> ```

如果这时还要使用 CommonJS 模块，那么需要将 CommonJS 脚本的后缀名都改成`.cjs`。如果没有`type`字段，或者`type`字段为`commonjs`，则`.js`脚本会被解释成 CommonJS 模块。

总结为一句话：`.mjs`文件总是以 ES6 模块加载，`.cjs`文件总是以 CommonJS 模块加载，`.js`文件的加载取决于`package.json`里面`type`字段的设置。

注意，ES6 模块与 CommonJS 模块尽量不要混用。`require`命令不能加载`.mjs`文件，会报错，只有`import`命令才可以加载`.mjs`文件。反过来，`.mjs`文件里面也不能使用`require`命令，必须使用`import`，浏览器支持ES6 Import。

CommonJS

1. 对于基本数据类型，属于复制。即会被模块缓存。同时，在另一个模块可以对该模块输出的变量重新赋值。
2. 对于复杂数据类型，属于浅拷贝。由于两个模块引用的对象指向同一个内存空间，因此对该模块的值做修改时会影响另一个模块。
3. 当使用require命令加载某个模块时，就会运行整个模块的代码。
4. 当使用require命令加载同一个模块时，不会再执行该模块，而是取到缓存之中的值。也就是说，CommonJS模块无论加载多少次，都只会在第一次加载时运行一次，以后再加载，就返回第一次运行的结果，除非手动清除系统缓存。
5. 循环加载时，属于加载时执行。即脚本代码在require的时候，就会全部执行。一旦出现某个模块被"循环加载"，就只输出已经执行的部分，还未执行的部分不会输出。

ES6模块

1. ES6模块中的值属于【动态只读引用】。
2. 对于只读来说，即不允许修改引入变量的值，import的变量是只读的，不论是基本数据类型还是复杂数据类型。当模块遇到import命令时，就会生成一个只读引用。等到脚本真正执行时，再根据这个只读引用，到被加载的那个模块里面去取值。
3. 对于动态来说，原始值发生变化，import加载的值也会发生变化。不论是基本数据类型还是复杂数据类型。
4. 循环加载时，ES6模块是动态引用。只要两个模块之间存在某个引用，代码就能够执行。

**UMD** 叫做通用模块定义规范（Universal Module Definition）。也是随着大前端的趋势所诞生，它可以通过运行时或者编译时让同一个代码模块在使用 CommonJs、CMD 甚至是 AMD 的项目中运行。未来同一个 JavaScript 包运行在浏览器端、服务区端甚至是 APP 端都只需要遵守同一个写法就行了。

它没有自己专有的规范，是集结了 CommonJs、CMD、AMD 的规范于一身，举例实现

```js
((root, factory) => {
    if (typeof define === 'function' && define.amd) {
        //AMD
        define(['jquery'], factory);
    } else if (typeof exports === 'object') {
        //CommonJS
        var $ = requie('jquery');
        module.exports = factory($);
    } else {
        root.testModule = factory(root.jQuery);
    }
})(this, ($) => {
    //todo
});
```

### js的6个属性描述对象

（1）`value`是该属性的属性值，默认为`undefined`。

（2）`writable`是一个布尔值，表示属性值（value）是否可改变（即是否可写），默认为`true`。

（3）`enumerable`是一个布尔值，表示该属性是否可遍历，默认为`true`。如果设为`false`，会使得某些操作（比如`for...in`循环、`Object.keys()`）跳过该属性。

（4）`configurable`是一个布尔值，表示可配置性，默认为`true`。如果设为`false`，将阻止某些操作改写该属性，比如无法删除该属性，也不得改变该属性的属性描述对象（`value`属性除外）。也就是说，`configurable`属性控制了属性描述对象的可写性。

（5）`get`是一个函数，表示该属性的取值函数（getter），默认为`undefined`。

（6）`set`是一个函数，表示该属性的存值函数（setter），默认为`undefined`。



### 浏览器输入url按下回车后发生了什么

> https://zhuanlan.zhihu.com/p/78677852

总体来说分为以下几个过程：

1. 输入地址。
2. DNS解析。
3. TCP连接。
4. 发送http请求。
5. 返回http响应。
6. 浏览器解析渲染页面。
7. 断开连接。

一、输入地址：

当我们在浏览器输入地址的时候，浏览器已经在只能匹配到可能得到的url了，他会从历史记录，书签等地方，找到已经输入的字符串可能对应的 url，然后给出智能提示，让你可以补全url地址。

二、DNS解析：

DNS解析的过程就是寻找哪台机器上有你需要资源的过程。当你在浏览器中输入一个地址时，例如[http://www.baidu.com](https://link.zhihu.com/?target=http%3A//www.baidu.com)，其实不是百度网站真正意义上的地址。互联网上每一台计算机的唯一标识是它的IP地址，但是IP地址并不方便记忆。用户更喜欢用方便记忆的网址去寻找互联网上的其它计算机，也就是上面提到的百度的网址。所以互联网设计者需要在用户的方便性与可用性方面做一个权衡，这个权衡就是一个网址到IP地址的转换，这个过程就是DNS解析。

解析过程：

1. 查找浏览器缓存：因为浏览器一般会缓存DNS记录一段时间，不同浏览器的时间可能不一样，一般2-30分钟不等，浏览器去查找这些缓存，如果有缓存，直接返回IP，否则下一步。
2. 查找系统缓存：浏览器缓存中找不到IP之后，浏览器会查看本地硬盘的 hosts 文件，看看其中有没有和这个域名对应的规则，如果有的话就直接使用 hosts 文件里面的 ip 地址。
3. 如果在本地的 hosts 文件没有能够找到对应的 ip 地址，浏览器会发出一个 DNS请求到本地DNS服务器 。
4. 查询你输入的网址的DNS请求到达本地DNS服务器之后，本地DNS服务器会首先查询它的缓存记录，如果缓存中有此条记录，就可以直接返回结果，此过程是递归的方式进行查询。如果没有，本地DNS服务器还要向DNS根服务器进行查询。
5. 根DNS服务器没有记录具体的域名和IP地址的对应关系，而是告诉本地DNS服务器，你可以到域服务器上去继续查询，并给出域服务器的地址。这种过程是迭代的过程。
6. 本地DNS服务器继续向域服务器发出请求，在这个例子中，请求的对象是.com域服务器。.com域服务器收到请求之后，也不会直接返回域名和IP地址的对应关系，而是告诉本地DNS服务器，你的域名的解析服务器的地址。
7. 最后，本地DNS服务器向域名的解析服务器发出请求，这时就能收到一个域名和IP地址对应关系，本地DNS服务器不仅要把IP地址返回给用户电脑，还要把这个对应关系保存在缓存中，以备下次别的用户查询时，可以直接返回结果，加快网络访问。

DNS查询的两种方式：

1、递归解析：

当局部DNS服务器自己不能回答客户机的DNS查询时，它就需要向其他DNS服务器进行查询。此时有两种方式，如图所示的是递归方式。局部DNS服务器自己负责向其他DNS服务器进行查询，一般是先向该域名的根域服务器查询，再由根域名服务器一级级向下查询。最后得到的查询结果返回给局部DNS服务器，再由局部DNS服务器返回给客户端。

![img](https://pic2.zhimg.com/80/v2-ea4f5f5cf28a9a6e166c4fc11b37ad21_720w.jpg)

2、迭代解析：

当局部DNS服务器自己不能回答客户机的DNS查询时，也可以通过迭代查询的方式进行解析，如图所示。局部DNS服务器不是自己向其他DNS服务器进行查询，而是把能解析该域名的其他DNS服务器的IP地址返回给客户端DNS程序，客户端DNS程序再继续向这些DNS服务器进行查询，直到得到查询结果为止。也就是说，迭代解析只是帮你找到相关的服务器而已，而不会帮你去查。

![img](https://pic2.zhimg.com/80/v2-4e0687456ae11fc76b0a77fc7e55eb21_720w.jpg)



三、TCP连接：

主机浏览器通过DNS解析得到了目标服务器的IP地址后，与服务器建立TCP连接。

TCP三次握手：

第一次握手：客户端将标志位SYN置为1,随机产生一个值为seq=J（J的取值范围为=1234567）的数据包到服务器，客户端进入SYN_SENT状态，等待服务端确认；

第二次握手：服务端收到数据包后由标志位SYN=1知道客户端请求建立连接，服务端将标志位SYN和ACK都置为1，ack=J+1，随机产生一个值seq=K，并将该数据包发送给客户端以确认连接请求，服务端进入SYN_RCVD状态。

第三次握手：客户端收到确认后，检查ack是否为J+1，ACK是否为1，如果正确则将标志位ACK置为1，ack=K+1，并将该数据包发送给服务端，服务端检查ack是否为K+1，ACK是否为1，如果正确则连接建立成功，完成三次握手，随后客户端A与服务端B之间可以开始传输数据了。

为什么需要三次握手：

三次握手的目的是“为了防止已失效的连接请求报文段突然又传送到了服务端，因而产生错误。

四、发送http请求：

建立了TCP连接之后，发起一个http请求。一个典型的 http request header 一般需要包括请求的方法，例如 GET 或者 POST 等，不常用的还有 PUT 和 DELETE 、HEAD、OPTION以及 TRACE 方法。

五、返回http响应：

服务器接受并处理完请求，返回 HTTP 响应，一个响应报文格式基本等同于请求报文，由响应行、响应头、空行、实体组成。

六、浏览器解析渲染页面：

浏览器是一个边解析边渲染的过程。首先浏览器解析HTML文件构建DOM树，然后解析CSS文件构建渲染树，等到渲染树构建完成后，浏览器开始布局渲染树并将其绘制到屏幕上。这个过程比较复杂，涉及到两个概念:  reflow(回流)和repain(重绘)。DOM节点中的各个元素都是以盒模型的形式存在，这些都需要浏览器去计算其位置和大小等，这个过程称为relow;当盒模型的位置,大小以及其他属性，如颜色,字体,等确定下来之后，浏览器便开始绘制内容，这个过程称为repain。页面在首次加载时必然会经历reflow和repain。reflow和repain过程是非常消耗性能的，尤其是在移动设备上，它会破坏用户体验，有时会造成页面卡顿。所以我们应该尽可能少的减少reflow和repain。

浏览器两种渲染方式：

webkit的主要流程：

![img](https://pic2.zhimg.com/80/v2-ad2b8a9617646bb212b70c556cdb5759_720w.jpg)

Geoko的主要流程：

![img](https://pic4.zhimg.com/80/v2-2eb78d456d03dcf2e02f78a1bd81896f_720w.jpg)

详细介绍请参考：

[浏览器渲染原理及流程 - 李某龙 - 博客园](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/slly/p/6640761.html)[www.cnblogs.com![图标](https://pic3.zhimg.com/v2-b2b7c07bd7f5af231cdeaa0c3804a686_180x120.jpg)](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/slly/p/6640761.html)

七、断开连接：

TCP四次挥手：

第一次挥手：Client发送一个FIN，用来关闭Client到Server的数据传送，Client进入FIN_WAIT_1状态。

第二次挥手：Server收到FIN后，发送一个ACK给Client，确认序号为收到序号+1（与SYN相同，一个FIN占用一个序号），Server进入CLOSE_WAIT状态。

第三次挥手：Server发送一个FIN，用来关闭Server到Client的数据传送，Server进入LAST_ACK状态。

第四次挥手：Client收到FIN后，Client进入TIME_WAIT状态，接着发送一个ACK给Server，确认序号为收到序号+1，Server进入CLOSED状态，完成四次挥手。

参考文献：

[从输入url到页面展示到底发生了什么 - 都市烟火 - 博客园](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/duhuo/p/5172479.html)