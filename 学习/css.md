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



## box-sizing 

box-sizing属性可以被用来调整这些表现:

- `content-box` 是默认值。如果你设置一个元素的宽为100px，那么这个元素的内容区会有100px 宽，并且任何边框和内边距的宽度都会被增加到最后绘制出来的元素宽度中。

- `border-box` 告诉浏览器：你想要设置的边框和内边距的值是包含在width内的。也就是说，如果你将一个元素的width设为100px，那么这100px会包含它的border和padding，内容区的实际宽度是width减去(border + padding)的值。大多数情况下，这使得我们更容易地设定一个元素的宽高。

- `border-box`不包含`margin`

