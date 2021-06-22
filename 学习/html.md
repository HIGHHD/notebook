### 表单

**`<input>`的value属性**

value 属性为 input 元素设定值。

对于不同的输入类型，value 属性的用法也不同：

- type="button", "reset", "submit" - 定义按钮上的显示的文本
- type="text", "password", "hidden" - 定义输入字段的初始值
- type="checkbox", "radio", "image" - 定义与输入相关联的值

`<input type="checkbox"> `和 `<input type="radio"> `中必须设置 value 属性，未设置时，默认为`on`，value属性和checked无关。

value 属性无法与 `<input type="file">` 一同使用。

示例：

```html
	<form action="https://www.freecatphotoapp.com/submit-cat-photo">
      <label for="indoor"><input id="indoor" type="radio" name="indoor-outdoor" value="indoor"> Indoor</label>
      <label for="outdoor"><input id="outdoor" type="radio" name="indoor-outdoor" value="outdoor"> Outdoor</label><br>
      <label for="loving"><input id="loving" type="checkbox" name="personality" value="loving"> Loving</label>
      <label for="lazy"><input id="lazy" type="checkbox" name="personality" value="lazy"> Lazy</label>
      <label for="energetic"><input id="energetic" type="checkbox" name="personality" value="energetic"> Energetic</label><br>
      <input type="text" placeholder="cat photo URL" required>
      <button type="submit">Submit</button>
    </form>
<!-- 在点选checkbox后，url为如下 https://www.freecatphotoapp.com/submit-cat-photo?indoor-outdoor=indoor&personality=loving&personality=lazy&personality=energetic -->
```

**`label`元素**

用于表示用户界面中某个元素的说明。将一个 `<label>` 和一个`<input>`元素相关联主要有这些优点：

- 标签文本不仅与其相应的文本输入元素在视觉上相关联，程序中也是如此。 这意味着，当用户聚焦到这个表单输入元素时，屏幕阅读器可以读出标签，让使用辅助技术的用户更容易理解应输入什么数据。
- 你可以点击关联的标签来聚焦或者激活这个输入元素，就像直接点击输入元素一样。这扩大了元素的可点击区域，让包括使用触屏设备在内的用户更容易激活这个元素。

将一个 `<label>` 和一个 `<input>` 元素匹配在一起，你需要给 `<input>` 一个 `id` 属性。而 `<label>` 需要一个 `for` 属性，其值和  `<input>` 的 `id` 一样；另外，你也可以将 `<input>` 直接放在 `<label>` 里，此时则不需要 `for` 和 `id` 属性，因为关联已隐含存在。

不要在 `label` 元素内部放置可交互的元素，比如 [anchors](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/a) 或 [buttons](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/button)。这样做会让用户更难激活/触发与 `label` 相关联的表单输入元素。

在一个 `<label>` 元素内部放置标题元素（[heading elements](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements)）会干扰许多辅助技术，原因是标题通常被用于辅助导航（[a navigation aid](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements#navigation)）。若标签内的文本需要做视觉上的调整，应该使用适用于 `<label>` 元素的 CSS 类。

若一个 [表单](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form)，或表单中的一部分需要一个标题，应使用`<legend>`元素置于`<fieldset>`元素中

### 标签分类

> https://html.spec.whatwg.org/multipage/indices.html#element-content-categories

有六种不同的元素：void （空）元素、模板元素、原始文本元素、可转义原始文本元素、外来元素和普通元素。

不是所有元素都拥有开始标签，内容，结束标签，这类元素称为空元素，有：`area, base, br, col, embed, hr, img, input, link, meta, param, source, track, wbr`，模板元素`template`,原始文本元素`script, style`,可转义原始文本元素`textarea`, `title`，外来元素有来自于`math`，`svg`的元素

**Namespaces**

The HTML namespace is "`http://www.w3.org/1999/xhtml`".

The MathML namespace is "`http://www.w3.org/1998/Math/MathML`".

The SVG namespace is "`http://www.w3.org/2000/svg`".

The XLink namespace is "`http://www.w3.org/1999/xlink`".

The XML namespace is "`http://www.w3.org/XML/1998/namespace`".

The XMLNS namespace is "`http://www.w3.org/2000/xmlns/`".