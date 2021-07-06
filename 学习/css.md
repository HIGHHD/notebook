# CSS

> [CSS 参考 - CSS（层叠样式表） | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Reference)

> [CSS 选择器 - CSS（层叠样式表） | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Selectors)

当浏览器显示文档时，它必须将文档的内容与其样式信息结合起来。
它分多个阶段处理文档，我们在下面列出了这些阶段的简化版本。

浏览器加载 HTML（例如从网络接收它）。
它将 HTML 转换为 DOM（文档对象模型）。 
DOM 代表计算机内存中的文档。
浏览器然后获取大多数由 HTML 文档链接的资源，例如嵌入的图像和视频......以及链接的 CSS！
在此过程中稍后会处理 JavaScript，
浏览器解析获取的 CSS，并按选择器类型将不同的规则分类到不同的“桶”中，例如元素、类、ID 等。
根据它找到的选择器，它计算出应该将哪些规则应用于 DOM 中的哪些节点，并根据需要为它们附加样式（这个中间步骤称为渲染树）。
在应用规则之后，渲染树被布置在它应该出现的结构中。
页面的视觉显示显示在屏幕上（这个阶段称为绘画）



## 回流(reflow)和重绘(repaint)

**html 加载时发生了什么**

1. 解析HTML，生成DOM树，解析CSS，生成CSSOM树
2. 将DOM树和CSSOM树结合，生成渲染树(Render Tree)
3. Layout(回流):根据生成的渲染树，进行回流(Layout)，得到节点的几何信息（位置，大小）
4. Painting(重绘):根据渲染树以及回流得到的几何信息，得到节点的绝对像素
5. Display:将像素发送给GPU，展示在页面上。

为了构建渲染树，浏览器主要完成了以下工作：

1. 从DOM树的根节点开始遍历每个可见节点。
2. 对于每个可见的节点，找到CSSOM树中对应的规则，并应用它们。
3. 根据每个可见节点以及其对应的样式，组合生成渲染树。

第一步中，既然说到了要遍历可见的节点，那么我们得先知道，什么节点是不可见的。不可见的节点包括：

- 一些不会渲染输出的节点，比如script、meta、link等。
- 一些通过css进行隐藏的节点。比如display:none。注意，利用visibility和opacity隐藏的节点，还是会显示在渲染树上的。只有display:none的节点才不会显示在渲染树上。

**回流**

前面我们通过构造渲染树，我们将可见DOM节点以及它对应的样式结合起来，可是我们还需要计算它们在设备视口(viewport)内的确切位置和大小，这个计算的阶段就是回流。

**重绘**

最终，我们通过构造渲染树和回流阶段，我们知道了哪些节点是可见的，以及可见节点的样式和具体的几何信息(位置、大小)，那么我们就可以将渲染树的每个节点都转换为屏幕上的实际像素，这个阶段就叫做重绘节点。

既然知道了浏览器的渲染过程后，我们就来探讨下，何时会发生回流重绘。

**何时发生回流重绘**

我们前面知道了，回流这一阶段主要是计算节点的位置和几何信息，那么当页面布局和几何信息发生变化的时候，就需要回流。比如以下情况：

- 添加或删除可见的DOM元素
- 元素的位置发生变化
- 元素的尺寸发生变化（包括外边距、内边框、边框大小、高度和宽度等）
- 内容发生变化，比如文本变化或图片被另一个不同尺寸的图片所替代。
- 页面一开始渲染的时候（这肯定避免不了，所以每个页面都至少回流重绘一次）
- 浏览器的窗口尺寸变化（因为回流是根据视口的大小来计算元素的位置和大小的）

*注意：回流一定会触发重绘，而重绘不一定会回流*

**浏览器的优化机制**

现代的浏览器都是很聪明的，由于每次重排都会造成额外的计算消耗，因此大多数浏览器都会通过队列化修改并批量执行来优化重排过程。浏览器会将修改操作放入到队列里，直到过了一段时间或者操作达到了一个阈值，才清空队列。但是！**当你获取布局信息的操作的时候，会强制队列刷新**，比如当你访问以下属性或者使用以下方法：

- offsetTop、offsetLeft、offsetWidth、offsetHeight
- scrollTop、scrollLeft、scrollWidth、scrollHeight
- clientTop、clientLeft、clientWidth、clientHeight
- getComputedStyle()
- getBoundingClientRect
- 具体可以访问这个网站：[https://gist.github.com/pauli...](https://gist.github.com/paulirish/5d52fb081b3570c81e3a)

以上属性和方法都需要返回最新的布局信息，因此浏览器不得不清空队列，触发回流重绘来返回正确的值。因此，我们在修改样式的时候，**最好避免使用上面列出的属性，他们都会刷新渲染队列。**如果要使用它们，最好将值缓存起来

**减少回流和重绘**

批量处理，例如样式的批量修改：

```js
// 发生了三次修改，每一个都会影响元素的几何结构，引起回流
const el = document.getElementById('test');
el.style.padding = '5px';
el.style.borderLeft = '1px';
el.style.borderRight = '2px';
// 使用cssText
const el = document.getElementById('test');
el.style.cssText += 'border-left: 1px; border-right: 2px; padding: 5px;';
// 修改CSS的class, class中指定元素样式
const el = document.getElementById('test');
el.className += ' active';
```

**批量修改DOM的方法**

当我们需要对DOM对一系列修改的时候，可以通过以下步骤减少回流重绘次数：

1. 使元素脱离文档流
2. 对其进行多次修改
3. 将元素带回到文档中。

该过程的第一步和第三步可能会引起回流，但是经过第一步之后，对DOM的所有修改都不会引起回流，因为它已经不在渲染树了。

有三种方式可以让DOM脱离文档流：

- 隐藏元素，应用修改，重新显示
- 使用文档片段(document fragment)在当前DOM之外构建一个子树，再把它拷贝回文档。
- 将原始元素拷贝到一个脱离文档的节点中，修改节点后，再替换原始的元素。

**避免触发同步布局事件**

上文我们说过，当我们访问元素的一些属性的时候，会导致浏览器强制清空队列，进行强制同步布局。举个例子，比如说我们想将一个p标签数组的宽度赋值为一个元素的宽度，我们可能写出这样的代码：

```js
function initP() {
    for (let i = 0; i < paragraphs.length; i++) {
        paragraphs[i].style.width = box.offsetWidth + 'px';
    }
}
```

这段代码看上去是没有什么问题，可是其实会造成很大的性能问题。在每次循环的时候，都读取了box的一个offsetWidth属性值，然后利用它来更新p标签的width属性。这就导致了每一次循环的时候，浏览器都必须先使上一次循环中的样式更新操作生效，才能响应本次循环的样式读取操作。每一次循环都会强制浏览器刷新队列。我们可以优化为:

```js
const width = box.offsetWidth;
function initP() {
    for (let i = 0; i < paragraphs.length; i++) {
        paragraphs[i].style.width = width + 'px';
    }
}
```

**css3硬件加速（GPU加速）**

比起考虑如何减少回流重绘，我们更期望的是，根本不要回流重绘。这个时候，css3硬件加速就闪亮登场啦！！

**划重点：使用css3硬件加速，可以让transform、opacity、filters这些动画不会引起回流重绘 。但是对于动画的其它属性，比如background-color这些，还是会引起回流重绘的，不过它还是可以提升这些动画的性能。**

本篇文章只讨论如何使用，暂不考虑其原理，之后有空会另外开篇文章说明。

**如何使用**

常见的触发硬件加速的css属性：

- transform
- opacity
- filters
- Will-change

**重点**

- 使用css3硬件加速，可以让transform、opacity、filters这些动画不会引起回流重绘
- 对于动画的其它属性，比如background-color这些，还是会引起回流重绘的，不过它还是可以提升这些动画的性能。

**css3硬件加速的坑**

- 如果你为太多元素使用css3硬件加速，会导致内存占用较大，会有性能问题。
- 在GPU渲染字体会导致抗锯齿无效。这是因为GPU和CPU的算法不同。因此如果你不在动画结束的时候关闭硬件加速，会产生字体模糊。



## Flex 容器

Flex 布局需要在一个容器中实现，这个容器叫做 flex 容器，可以通过 display 属性来声明，声明一个 flex 容器的值并不只有 flex，同时还有 inline-flex；前者对应块状元素，而后者则是行内元素。当声明了一个 flex 容器后，这个容器子元素的 float、clear、vertical-align 属性都将会失效；

```css
.container {
    display: flex;
}
```

**flex-direction**

这个属性名其实很好理解，就是设置容器中的 flex item 的排列方向的，它有下面几个值：

1. row <水平从左向右排列>
2. row-reverse <水平从右向左排列>
3. column <垂直从上到下排列>
4. column-reverse <垂直从下到上排列>

**flex-wrap**

在不设置这个属性的情况下，当所有 flex item 的总长度超过容器长度时，item 会超出容器，并不会换行

1. nowrap <默认值，不换行>
2. wrap <换行，新的一行在下面>
3. wrap-reverse <换行，旧的一行在下面>

**flex-flow**

这个属性就很简单了，是上面两个属性的缩写，属性可以接受两个值，一个是 flex-direction 的值，另一个是 flex-wrap 的值

**justify-content**

这个属性的作用是决定 item 在他们的排列方向（当前是 row，水平向右）上的对齐方式

1. flex-start <默认值，排列方向起始位置对齐>
2. flex-end <排列方向结束位置对齐>
3. center <居中对齐>
4. space-between <两端对齐，如果有剩余空间，则等分成间隙>
5. space-around <均匀分布，如果有空隙，两端会存在空隙，且两端空隙为中间空隙的一半>

**align-items**

这个属性也是决定对齐方式的，但与上一个属性不同的是，它决定了单行元素按照哪种方式在垂直方向对齐

1. stretch <默认值，在 item 未设置高度的情况下，item的高将占满容器，这样每个 item 的高度都相同>
2. flex-start <item 之间在起始位置（这里是顶部）对齐>
3. flex-end <item 之间在结束位置（这里是底部）对齐>
4. center <item 之间中部对齐>
5. baseline <item 以它们内部第一行文字的基线为准对齐>

**align-content**

这个属性定义了当有多行时 item 之间的对齐方式，可以将对齐元素理解为每一行

1. stretch <默认值，在 item 未设置高度的情况下，item的高将占满这一行，这样每个 item 的高度都相同>
2. flex-start <item 在起始位置（这里是顶部）对齐>
3. flex-end <item 在结束位置（这里是底部）对齐>
4. center <item 之间中部对齐>
5. space-between <两端对齐，如果有剩余空间则平分成为间隙>
6. space-around <均匀分布，如果有空隙，两端会存在空隙，且两端空隙为中间空隙的一半>****

**flex**

该属性用于flex容器内元素，是flex-grow、flex-shrink、flex-basis

可以使用一个，两个或三个值来指定 `flex`属性。

单值语法: 值必须为以下其中之一:

- 一个无单位数: 它会被当作`flex:<number> 1 0;` `<flex-shrink>`的值被假定为1，然后`<flex-basis>` 的值被假定为`0`。
- 一个有效的**宽度([`width`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/width))**值: 它会被当作 `<flex-basis>的值。`
- 关键字`none`，`auto`或`initial`.

双值语法: 第一个值必须为一个无单位数，并且它会被当作 `<flex-grow>` 的值。第二个值必须为以下之一：

- 一个无单位数：它会被当作 `<flex-shrink>` 的值。
- 一个有效的宽度值: 它会被当作 `<flex-basis>` 的值。

三值语法:

- 第一个值必须为一个无单位数，并且它会被当作 `<flex-grow>` 的值。
- 第二个值必须为一个无单位数，并且它会被当作 `<flex-shrink>` 的值。
- 第三个值必须为一个有效的宽度值， 并且它会被当作 `<flex-basis>` 的值。

### [取值](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex#values)

- `initial`

  元素会根据自身宽高设置尺寸。它会缩短自身以适应 flex 容器，但不会伸长并吸收 flex 容器中的额外自由空间来适应 flex 容器 。相当于将属性设置为"`flex: 0 1 auto`"。

- `auto`

  元素会根据自身的宽度与高度来确定尺寸，但是会伸长并吸收 flex 容器中额外的自由空间，也会缩短自身来适应 flex 容器。这相当于将属性设置为 "`flex: 1 1 auto`".

- `none`

  元素会根据自身宽高来设置尺寸。它是完全非弹性的：既不会缩短，也不会伸长来适应 flex 容器。相当于将属性设置为"`flex: 0 0 auto`"。

- `<'flex-grow'>`

  定义 flex 项目的 [`flex-grow`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex-grow) 。负值无效。省略时默认值为 1。 (初始值为 `0`)

- `<'flex-shrink'>`

  定义 flex 元素的 [`flex-shrink`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex-shrink) 。负值无效。省略时默认值为`1`。 (初始值为 `1`)

- `<'flex-basis'>`

  定义 flex 元素的 [`flex-basis`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/flex-basis) 属性。若值为`0`，则必须加上单位，以免被视作伸缩性。省略时默认值为 0。(初始值为 auto)



## grid布局

CSS**网格布局**和**弹性盒布局**的主要区别在于[弹性盒布局](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout)是为一维布局服务的（沿横向或纵向的），而网格布局是为二维布局服务的（同时沿着横向和纵向）。这两个规格有一些相同的特性。

​		除了一维和二维布局之间的区别，还有一种办法决定该使用弹性盒还是网格来布局。弹性盒从内容出发。一个使用弹性盒的理想情形是你有一组元素，希望它们能平均地分布在容器中。你让内容的大小决定每个元素占据多少空间。如果元素换到了新的一行，它们会根据新行的可用空间决定它们自己的大小。网格则从布局入手。当使用CSS网格时，你先创建网格，然后再把元素放入网格中，或者让自动放置规则根据把元素按照网格排列。我们能创建根据内容改变大小的网格轨道，但整个轨道的大小都会随之改变。

​		当你使用弹性盒，并发现自己禁用了一些弹性特性，那你可能需要的是CSS网格布局。例如，你给一个弹性元素设置百分比宽度来使它和上一行的元素对齐。这种情况下，网格很可能是一个更好的选择。

将拥有`display: grid`属性元素所包含的所有元素，使用网格布局，网格是一组相交的水平线和垂直线，它定义了网格的列和行。我们可以将网格元素放置在与这些行和列相关的位置上。CSS网格布局具有以下特点：

### 固定的位置和弹性的轨道的大小

你可以使用固定的轨道尺寸创建网格，比如使用像素单位。你也可以使用比如百分比或者专门为此目的创建的新单位 `fr`来创建有弹性尺寸的网格。有着多轨道的大型网格可使用 `repeat()` 标记来重复部分或整个轨道列表。如下方的网格定义：

```css
.wrapper {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 200px; /* 也可写成 grid-template-columns: repeat(3, 1fr) 200px; */
}
```

涉及属性：

```
grid-template-columns,grid-template-rows,grid-auto-columns,grid-auto-rows,grid-template-area,grid-template
grid-template 是grid-template-area，grid-template-columns，grid-template-rows的缩写
```

轨道大小可以用`minmax`函数来控制最大值和最小值

```
.wrapper {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-auto-rows: minmax(100px, auto);
}
```

### 元素位置

你可以使用行号、行名或者标定一个网格区域来精确定位元素。网格同时还使用一种算法来控制未给出明确网格位置的元素。

涉及属性：

```
grid-column-start, grid-column-end, grid-row-start 和 grid-row-end,grid-column,grid-row，grid-area
grid-area是对grid-column-start, grid-column-end, grid-row-start 和 grid-row-end的缩写
```

这4个属性，值起始为1，列最大值为列数或+1，行没有最大值，列为负数，则倒序数数

### 创建额外的轨道来包含元素

可以使用网格布局定义一个显式网格，但是根据规范它会处理你加在网格外面的内容，当必要时它会自动增加行和列，它会尽可能多的容纳所有的列。

### 对齐控制

网格包含对齐特点，以便我们可以控制一旦放置到网格区域中的物体对齐，以及整个网格如何对齐。

### 控制重叠内容

多个元素可以放置在网格单元格中，或者区域可以部分地彼此重叠。然后可以CSS中的`z-index`属性来控制重叠区域显示的优先级。

Grid是一个强大的规范，当与CSS的其他部分（如[flexbox](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout)）结合使用时，可以帮助您创建以前不可能在CSS中构建的布局。这一切都是通过在网格容器上创建一个网格来开始的。

### 网格间隙

```
grid-column-gap,grid-row-gap,grid-gap
```

### 布局方式

`grid-auto-flow`属性控制着自动布局算法怎样运作，精确指定在网格中被自动布局的元素怎样排列。

```css
grid-auto-flow: row;
grid-auto-flow: column;
grid-auto-flow: dense;
grid-auto-flow: row dense;
grid-auto-flow: column dense;
```

`row`

该关键字指定自动布局算法按照通过逐行填充来排列元素，在必要时增加新行。如果既没有指定 `row` 也没有 `column`，则默认为 `row`。

`column`

该关键字指定自动布局算法通过逐列填充来排列元素，在必要时增加新列。

`dense`

该关键字指定自动布局算法使用一种“稠密”堆积算法，如果后面出现了稍小的元素，则会试图去填充网格中前面留下的空白。这样做会填上稍大元素留下的空白，但同时也可能导致原来出现的次序被打乱。

如果省略它，使用一种「稀疏」算法，在网格中布局元素时，布局算法只会「向前」移动，永远不会倒回去填补空白。这保证了所有自动布局元素「按照次序」出现，即使可能会留下被后面元素填充的空白。

### 网格和绝对定位元素

要使网格容器成为一个包含块，需要为容器增加 `position` 属性，并把它的值设置为 `relative`，当然也可以是其他非`static`，就像为任何其他绝对定位的项目创建一个包含块一样。接下来，如果再把一个网格项目设置为 `position: absolute`，那么网格容器就成为包含块，或者如果该项目具有网格定位的属性，那么被放置的网格就成为包含块。

在下面的例子中，一个容器中包含了四个子项。第三项是绝对定位的，并且使用基于行定位的方式把自己放置在网格中，它的left，top基于自身的`row-start，column-start`。网格容器具有 `position: relative` 属性，因此网格就成为该项目的定位上下文。

```html
<style>
.wrapper {
   display: grid;
   grid-template-columns: repeat(4,1fr);
   grid-auto-rows: 200px;
   grid-gap: 20px;
   position: relative;
}
.box3 {
   grid-column-start: 2;
   grid-column-end: 4;
   grid-row-start: 1;
   grid-row-end: 3;
   position: absolute;
   top: 40px;
   left: 40px;
}
</style>
<div class="wrapper">
   <div class="box1">One</div>
   <div class="box2">Two</div>
   <div class="box3">
    This block is absolutely positioned. In this example the grid container is the containing block and so the absolute positioning offset values are calculated in from the outer edges of the area it has been placed into.
   </div>
   <div class="box4">Four</div>
</div>
```

### 网格和`display:content`

如果将项目设置为 `display: contents`，通常自身的盒子会消失，子元素的盒子仍显示，就像子元素在文档树中上升了一层。这意味着一个网格项目的子元素可以成为网格项目。

```
<style>
    .wrapper div {
      border: 1px solid lightgreen;
    }

    .wrapper {
      display: grid;
      /* grid-template-columns: repeat(3, 1fr);
      grid-auto-rows: minmax(100px, auto); */
      /* grid-template: 50px 60px 70px 80px / 100px 1fr; */
      grid-template: "a a a"100px "b b b"100px "c c c"100px;
    }
    
    .wrapper>div:first-child {
      grid-area: span 3 / span 2;
      background-color: #a39c9b;
    }

    #page {
      display: grid;
      /* 1.设置display为grid */
      width: 100%;
      height: 250px;
      /* grid-template-areas: "head head"
        "nav  main"
        "nav  foot";
      grid-template-rows: 50px 1fr 30px;
      grid-template-columns: 150px 1fr; */

      grid-template: "head head" 60px
      "nav main" 100px
      "nav foot" 60px / 120px 1fr;
    }

    #page>header {
      grid-area: head;
      /* 4. 指定当前元素所在的区域位置, 从grid-template-areas选取值 */
      background-color: #8ca0ff;
    }

    #page>nav {
      grid-area: nav;
      background-color: #ffa08c;
    }

    #page>main {
      grid-area: main;
      background-color: #ffff64;
    }

    #page>footer {
      grid-area: foot;
      background-color: #8cffa0;
    }
  </style>
</head>

<body>
  <div class="wrapper">
    <div class="box box1">One</div>
    <div class="box box2">Two</div>
    <div class="box box3">Three</div>
    <div class="box box4">Four</div>
    <div class="box box5">Five</div>
    <div class="box box6">Six</div>
    <div class="box box7">Seven</div>
    <div class="box box8">Eight</div>
    <div class="box box9">Nine</div>
  </div>
  <section id="page">
    <header>Header</header>
    <nav>Navigation</nav>
    <main>Main area</main>
    <footer>Footer</footer>
  </section>
</body>
```

### 多列布局

``` 
column-count 描述元素应该分为几列
column-rule 用于列与列之间的直线，是column-rule-width，column-rule-style 和 column-rule-color的组合简写
column-span 值被设置为all时，可以让一个元素跨越所有的列
column-gap 用于设置列之间的间隔
column-fill auto / balance 用于设置内容分配方式，默认为balance，列中内容有相同高度，auto内容只占用自身所需高度，超过容器高度后才会排列至另一列
column-width 用于设置列宽
columns column-width 和 column-count简写
```



## 基础盒模型

当对一个文档进行布局（lay out）的时候，浏览器的渲染引擎会根据标准之一的 **CSS 基础框盒模型**（**CSS basic box model**），将所有元素表示为一个个矩形的盒子（box）。CSS 决定这些盒子的大小、位置以及属性（例如颜色、背景、边框尺寸…）。

每个盒子由四个部分（或称*区域*）组成，其效用由它们各自的边界（Edge）所定义（原文：defined by their respective edges，可能意指容纳、包含、限制等）。如图，与盒子的四个组成区域相对应，每个盒子有四个边界：*内容边界* *Content edge*、*内边距边界* *Padding Edge*、*边框边界* *Border Edge*、*外边框边界* *Margin Edge*。

最后，请注意，除[可替换元素](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Replaced_element)外，对于行内元素来说，尽管内容周围存在内边距与边框，但其占用空间（每一行文字的高度）则由 [`line-height`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/line-height) 属性决定，即使边框和内边距仍会显示在内容周围。

## box-sizing 

box-sizing属性可以被用来调整这些表现:

- `content-box` 是默认值。如果你设置一个元素的宽为100px，那么这个元素的内容区会有100px 宽，并且任何边框和内边距的宽度都会被增加到最后绘制出来的元素宽度中。
- `border-box` 告诉浏览器：你想要设置的边框和内边距的值是包含在width内的。也就是说，如果你将一个元素的width设为100px，那么这100px会包含它的border和padding，内容区的实际宽度是width减去(border + padding)的值。大多数情况下，这使得我们更容易地设定一个元素的宽高。
- `border-box`不包含`margin`



## 可替换元素

在 [CSS](https://developer.mozilla.org/zh-CN/docs/Web/CSS) 中，**可替换元素**（**replaced element**）的展现效果不是由 CSS 来控制的。这些元素是一种外部对象，它们外观的渲染，是独立于 CSS 的。

简单来说，它们的内容不受当前文档的样式的影响。CSS 可以影响可替换元素的位置，但不会影响到可替换元素自身的内容。某些可替换元素，例如`iframe`元素，可能具有自己的样式表，但它们不会继承父文档的样式。

典型的可替换元素有：

- [`iframe`](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/iframe)
- [`video`](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/video)
- [`embed`](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/embed)
- [`img`](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/img)

有些元素仅在特定情况下被作为可替换元素处理，例如：

- [`option`](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/option)
- [`audio`](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/audio)
- [`canvas`](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/canvas)
- [`object`](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/object)

用 CSS [`content`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/content) 属性插入的对象是匿名的可替换元素。它们并不存在于 HTML 标记中，因此是“匿名的”。



## 匿名元素

匿名(anonymous)元素有两种: 匿名 block 元素 和 匿名 inline 元素。匿名元素是指原来的DOM树中不存在的元素，但是为了满足CSS标准 而出现的一种元素。如下

```html
<div>   
this is some text!    
<p>   
this is another text!    
</p>   
</div> 
```

```html
<div>   
<匿名block>   
this is some text!    
</匿名block>   
<p>   
this is anthoer text    
</p>   
</div>
```



## 布局和包含块

许多开发者认为一个元素的包含块就是他的父元素的内容区。但事实并非如此。接下来让我们来看看，确定元素包含块的因素都有哪些。

元素的尺寸及位置，常常会受它的包含块所影响。对于一些属性，例如 [`width`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/width), [`height`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/height), [`padding`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/padding), [`margin`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/margin)，绝对定位元素的偏移值 （比如 [`position`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/position) 被设置为 `absolute` 或 `fixed`），当我们对其赋予百分比值时，这些值的计算值，就是通过元素的包含块计算得来。

确定一个元素的包含块的过程完全依赖于这个元素的 [`position`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/position) 属性：

1. 如果 position 属性为 `static` 、 `relative` 或 `sticky`，包含块可能由它的最近的祖先**块元素**（比如说inline-block, block 或 list-item元素）的内容区的边缘组成，也可能会建立格式化上下文(比如说 a table container, flex container, grid container, 或者是 the block container 自身)。

2. 如果 position 属性为 `absolute` ，包含块就是由它的最近的 position 的值不是 `static` （也就是值为`fixed`, `absolute`, `relative` 或 `sticky`）的祖先元素的内边距区的边缘组成。

3. 如果 position 属性是 `fixed`，在连续媒体的情况下(continuous media)包含块是 [viewport](https://developer.mozilla.org/zh-CN/docs/Glossary/Viewport) ,在分页媒体(paged media)下的情况下包含块是分页区域(page area)。

4. 如果 position 属性是`absolute`或`fixed`，包含块也可能是由满足以下条件的最近父级元素的内边距区的边缘组成的：

   1.  [`transform`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/transform) 或 [`perspective`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/perspective) 的值不是 `none`
   2.  [`will-change`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/will-change) 的值是 `transform` 或 `perspective`
   3.  [`filter`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/filter) 的值不是 `none` 或 `will-change` 的值是 `filter`(只在 Firefox 下生效).
   4.  [`contain`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/contain) 的值是 `paint` (例如: `contain: paint;`)

**注意:** 根元素(<html>)所在的包含块是一个被称为**初始包含块**的矩形。他的尺寸是视口 viewport (for continuous media) 或分页媒体 page media (for paged media).

如上所述，如果某些属性被赋予一个百分值的话，它的计算值是由这个元素的包含块计算而来的。这些属性包括盒模型属性和偏移属性：

1. 要计算 [`height`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/height) [`top`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/top) 及 [`bottom`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/bottom) 中的百分值，是通过包含块的 `height` 的值。如果包含块的 `height` 值会根据它的内容变化，而且包含块的 `position` 属性的值被赋予 `relative` 或 `static` ，那么，这些值的计算值为 auto。
2. 要计算 [`width`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/width), [`left`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/left), [`right`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/right), [`padding`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/padding), [`margin`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/margin) 这些属性由包含块的 `width` 属性的值来计算它的百分值。



## 定位（position）和文档流

- **定位元素（positioned element）**是其[计算后](https://developer.mozilla.org/zh-CN/docs/Web/CSS/computed_value)位置属性为 `relative`, `absolute`, `fixed `或 `sticky` 的一个元素（换句话说，除`static`以外的任何东西）。
- **相对定位元素（relatively positioned element）**是[计算后](https://developer.mozilla.org/zh-CN/docs/Web/CSS/computed_value)位置属性为 `relative `的元素。
- **绝对定位元素（absolutely positioned element）**是[计算后](https://developer.mozilla.org/zh-CN/docs/Web/CSS/computed_value)位置属性为 `absolute` 或 `fixed` 的元素。
- **粘性定位元素（stickily positioned element）**是[计算后](https://developer.mozilla.org/zh-CN/docs/Web/CSS/computed_value)位置属性为 `sticky` 的元素。

定位元素可以使用`top`，`left`，`right`，`bottom`，来控制元素展示位置，区别在于参照物，绝对定位元素会脱离文档流，指定元素浮动也会脱离文档流

`static`

该关键字指定元素使用正常的布局行为，即元素在文档常规流中当前的布局位置。此时 `top`, `right`, `bottom`, `left` 和 `z-index `属性无效。

`relative`

该关键字下，元素先放置在未添加定位时的位置，再在不改变页面布局的前提下调整元素位置，也就是相对于自己本来该在的位置进行位置调整（因此会在此元素未添加定位时所在位置留下空白）。position:relative 对 table-*-group, table-row, table-column, table-cell, table-caption 元素无效。

`absolute`

元素会被移出正常文档流，并不为元素预留空间，通过指定元素相对于最近的非 static 定位祖先元素的偏移，来确定元素位置。绝对定位的元素可以设置外边距（margins），且不会与其他边距合并。

`fixed`

元素会被移出正常文档流，并不为元素预留空间，而是通过指定元素相对于屏幕视口（viewport）的位置来指定元素位置。元素的位置在屏幕滚动时不会改变。打印时，元素会出现在的每页的固定位置。`fixed` 属性会创建新的层叠上下文。当元素祖先的 `transform`, `perspective` 或 `filter` 属性非 `none` 时，容器由视口改为该祖先。



### 常用伪类

`:first-of-type`  匹配属于其父元素的特定类型的首个子元素，等同于`nth-of-type(1)`

选取嵌套元素的每一个，例：

```html
  <style>
  	/* article后的空格相当于 article *，选择器等同于article *:first-of-type 
      等同于 article div:first-of-type 和
      article div span:first-of-type
      article b:first-of-type
      article div em:first-of-type
  	*/
    article :first-of-type {
      background-color: pink;
    }
  </style>
  <article>
    <div>This `div` is first!</div>
    <div>This <span>nested `span` is first</span>!</div>
    <div>This <em>nested `em` is first</em>, but this <em>nested `em` is last</em>!</div>
    <div>This <span>nested `span` gets styled</span>!</div>
    <b>This `b` qualifies!</b>
    <div>This is the final `div`.</div>
  </article>
```

`:nth-of-type()`针对具有一组兄弟节点的标签, 用 n 来筛选出在一组兄弟节点的位置。

`:nth-child:`表示父元素下兄弟元素的选择，使用 n 来表示选择逻辑，示例：

`tr:nth-child(2n+1)` 或 `tr:nth-child(odd)` 表示HTML表格中的奇数行。

`tr:nth-child(2n)` 或 `tr:nth-child(even)` 表示HTML表格中的偶数行。

`span:nth-child(0n+1)` 表示子元素中第一个且为span的元素，与 [`:first-child`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/:first-child) 选择器作用相同。

`span:nth-child(1)` 表示父元素中子元素为第一的并且名字为span的标签被选中

`span:nth-child(-n+3)` 匹配前三个子元素中的span元素。

