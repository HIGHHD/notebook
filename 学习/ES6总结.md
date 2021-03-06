**var,let,const的区别**

1.var 变量可以提升，let，const变量不可以提升
2.var 没有暂时性死区，let，const有暂时性死区
3.var 允许重复声明，let，const不可以重复声明
4.var 和let可以修改声明的变量，const不可以修改
5.var 没有块级作用域，let和const有块级作用域

**箭头函数和function的区别**
1.箭头函数是匿名函数，不能作为构造函数，不能使用new
2.箭头函数内没有arguments，可以用展开运算符...解决
3.箭头函数的this，始终指向父级上下文（箭头函数的this取决于定义位置父级的上下文，跟使用位置没关系，普通函数this指向调用的那个对象）
4.箭头函数不能通过call() 、 apply() 、bind()方法直接修改它的this指向。(call、aaply、bind会默认忽略第一个参数，但是可以正常传参)
5.箭头函数没有原型属性

**原型，原型链**

JavaScript 只有一种结构：对象。每个实例对象（ object ）都有一个私有属性（称之为 `__proto__` ）指向它的构造函数的原型对象（**prototype** ）。该原型对象也有一个自己的原型对象( `__proto__` ) ，层层向上直到一个对象的原型对象为 `null`。根据定义，`null` 没有原型，并作为这个**原型链**中的最后一个环节。几乎所有 JavaScript 中的对象都是位于原型链顶端的 [`Object`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object) 的实例。

简述原型链：实例化对象的`__proto__`指向构造函数的prototype，构造函数prototype的`__proto__`指向`Object.prototype`，`Object.prototype`的`__proto__`指向`null`

```js
函数.prototype.constructor === 函数
```

```js
var a = {}	//实例化对象
a.__proto__ === a.constructor.prototype	//true
a.constructor.prototype === Object.prototype  //true
Object.prototype.__proto__ === null	//true
```

1.实例化对象和原型的constructor指向构造函数
2.构造函数的prototype属性指向原型对象
3.实例化对象的`__proto__`属性指向原型对象
4.javascript里面每个对象都有一个`__proto__`属性，这个属性就是他的原型
5.每个方法里面都有一个prototype属性，也是他的原型

`__proto__`不是标准实现的，但是各大浏览器和node都采用了，ECMA6计划标准化它，`__proto__`对应于标准中的[[prototype]]，也就是所谓的内置原型属性，要把它和函数的prototype的相区别，其实，`__proto__`最终是指向Function.prototype的，这也是和js函数第一性对应的，js有函数化编程的基因。

函数既有prototype属性也有[[prototype]]属性 也就是`__proto__`,其中prototype主要是为了实现类的继承，而`__proto__`只有对象才有，当然js中函数就是对象，所以函数也有`__proto__`,函数的`__proto__`就是指向Function.prototype的，对象只有`__proto__`,它是指向这个对象的构造函数的，对象没有prototype属性。

`__proto__`主要用来回溯对象，即用来继承的，即当执行a.b的时候，如果当前对象没有定义b属性，则会通过`a.__proto__`到父对象中查找，以此类推
`prototype`其值是函数的原型对象，该对象可以扩展，但不要直接赋值整个prototype，会打破原型链，其作用是将值传递给实例对象的`__proto__`，以实现继承，

函数的`prototype`属性，这是是函数的特有属性，在 JavaScript 中，函数（function）是允许拥有属性的，

**new 到底做了些什么**

> The **`new` operator** lets developers create an instance of a user-defined object type or of one of the built-in object types that has a constructor function.
>
> The **`new`** keyword does the following things:
>
> 1. Creates a blank, plain JavaScript object.
>
> 2. Adds a property to the new object (`__proto__`) that links to the constructor function's prototype object
>
>    **Note:** Properties/objects added to the construction function prototype are therefore accessible to all instances created from the constructor function (using `new`).
>
> 3. Binds the newly created object instance as the `this` context (i.e. all references to `this` in the constructor function now refer to the object created in the first step).
>
> 4. Returns `this` if the function doesn't return an object.

以构造器的prototype属性为原型，创建新对象（隐性执行）；

将this，也就是上一步的新对象和调用参数传给构造器，执行构造函数的代码；

返回新对象（隐性执行）；

```js
let Fu = function (name, age) {
    this.name_a = name;
    this.showName = function () {
        console.log(this.name, 'show')
    }
};
Fu.prototype.sayName = function () {
    console.log(this.name_a);
};
let Zi = function (name, age) {
    console.log('1', this)
    Fu.call(this, name);
    console.log('2', this)
    this.age = age;
    console.log('3', this)
}
Zi.prototype = new Fu();
// Zi.prototype.constructor = Zi;	// 为什么不需要这一步，因为Zi自身就在原型链上，Zi就是构造方法
//自己定义的new方法
let newMethod = function (O, ...rest) {
    // 1.以构造器的prototype属性为原型，创建新对象；
    //let o = Object.create(O.prototype);
    let o = {__proto__: O.prototype}; //都可以
    // 2.将this和调用参数传给构造器执行
    // O.call(o, ...rest);
    O.bind(o, ...rest)();
    console.log(O.name);
    // 3.返回第一步的对象
    return o;
};
//创建实例，将构造函数Fu与形参作为参数传入
const zi = newMethod(Zi, 'echo', 26);
const zi2 = new Zi('echo', 26);
// zi.sayName() //'echo';

//最后检验，与使用new的效果相同
zi instanceof Fu//true
zi.hasOwnProperty('name_a')//true
zi.hasOwnProperty('age')//true
zi2.hasOwnProperty('age')//true
zi.hasOwnProperty('sayName')//false
```



**继承**

1.原型链继承，将子类的原型链指向父类对象实例

优点：可继承构造函数的属性，父类构造函数的属性，父类原型的属性，且父类方法只创建一遍

缺点：无法向父类构造函数传参；且所有实例共享父类实例属性，父类属性为引用类型的话，更改一个子类实例，所有子类实例都将发生变化；继承单一，无法实现多继承

```js
function Fu(w){ this.arr=['red','blue','green'], this.x = w; } 
function Zi(w){ this.arr2 = ['gray'], this.y = w; } Zi.prototype=new Fu(); // 相当于打破了Zi的原型链，指向了Fu
var a = new Zi(); a.arr.push('black') 
var b = new Zi(); console.log(b.arr);
a.print0 === b.print0 // true
```

2.构造函数继承，在子类构造函数中使用call或者apply劫持父类构造函数方法，原理是使用call或apply更改子类构造函数this指针指向，因而继承父类属性

优点：可解决原型链继承的缺点

缺点：不可继承父类的原型链方法，父类方法不可复用，每次创建实例都会创建一遍方法

```js
function Fu(w){ this.arr=['red','blue','green'], this.x = w; this.print0 = function() {
    console.log('0');
}} 
function Zi(w){ this.arr2 = ['gray'], this.y = w; Fu.call(this, w)}
Fu.prototype.printarr = function() {
    console.log(this.arr);
}
var a = new Zi(1)
var b = new Fu(2)
// a.printarr()  // a.printarr is not a function
a.print0()
a.arr.push('black') // a.arr ["red", "blue", "green", "black"]
b.printarr()
b.print0()
var c = new Zi(3);
console.log(c.arr) // c.arr ["red", "blue", "green"]
a.print0 === c.print0 // false
```

3.组合继承，原型链继承和构造函数继承组合

优点：若父类的方法定义在原型对象上，可以实现方法复用，可以向父类构造函数传参，并且不共享父类的引用属性

缺点：构造函数内的方法任然不可以实现复用，调用了两次父类的构造方法(赋值prototype时)

```js
function Fu(name) {
    console.log('fu');
    this.name = name;
    this.colors = ['red','blue','green'];
    this.showName = function () {
        console.log(this.name, 'show')
    }
}
Fu.prototype.getName = function () {
    consolo.log(this.name);
}
function Zi(name, age) {
    Fu.call(this, name);
    this.age = age;
}
Zi.prototype = new Fu();	//这样才可以把Fu的属性加到Zi类
var zi = new Zi('z', '18');
zi.colors.push('block');
console.log(zi.name); // kevin
console.log(zi.age); // 18
console.log(zi.colors); // ["red", "blue", "green", "black"]
var zi2 = new Zi('daisy', '20');
console.log(zi2.name); // daisy
console.log(zi2.age); // 20
console.log(zi2.colors); // ["red", "blue", "green"]
```

4.组合继承优化方式

```js
function Fu(name) {
    console.log('fu');
    this.name = name;
    this.colors = ['red','blue','green'];
    this.showName = function () {
        console.log(this.name, 'show')
    }
}
Fu.prototype.getName = function () {
    console.log(this.name);
}
function Zi(name, age) {
    Fu.call(this, name);
    this.age = age;
}
Zi.prototype = Fu.prototype;	//优化调用两次父类构造方法，主要是获取Fu原型链上的属性，其他通过call获取
Zi.prototype = Object.create(Fu.prototype)	//优化原型链，Object.create,可以实现原型隔离，在子类原型添加修改方法不会影响父类，通过Object.create(Fu.prototype).__proto__任然可以找到getName
Zi.prototype.constructor = Zi; //个人觉得这一步可以略过，Zi本来就在最后一层原型链上
```

**class语法糖**

```js
class Fu {
    constructor(a) {
        this.a = a;
        this.colors = ['red','blue','green'];
        this.showName = function () {	//位于实例上
            console.log(this.a, 'show')
        }
    }
    showName2() {	//位于原型对象上
        console.log(this.a, 'show2')
    }
}
class Zi extends Fu {
    constructor(a) {
        super(a);
        this.b = a + 's'; //位于实例上
    }
    showName2() {	//位于原型对象上，和父类隔离
        console.log(this.a, 'show2')
    }
    showName3() {	//位于原型对象上
        console.log(this.b, 'show2')
    }
}
```



**Promise**

1.概述：Promise是异步编程的一种解决方案，从语法上讲，Promise是一个对象，可以获取异步操作的消息
2.目的： （1）避免回调地狱的问题（2）Promise对象提供了简洁的API，使得控制异步操作更加容易
3.Promise有三种状态：pendding //正在请求，rejected //失败，resolved //成功
4.基础用法：new Promise(function(resolve,reject){ })
resolved,rejected函数：在异步事件状态pendding->resolved回调成功时，通过调用resolved函数返回结果；当异步操作失败时，回调用rejected函数显示错误信息
