```html
<!DOCTYPE html>
<html>

<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge chrome=1">
  <title>学习</title>
  <!-- base 元素允许作者为解析 URL 的目的指定文档 base URL，一个文档只允许存在一个base，且必须有href或target属性，
    该元素从使用的角度来讲，要放在所有可能解析URL的元素之前 -->
  <base href="./html.html">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta name="viewport" content="width=device-width">
  <link rel="shortcut icon" href="./images/36x36.png">
</head>

<body>
  <header>
    <nav>
      <ul>
        <li> <a href="#">Home</a> </li>
        <li> <a href="#">News</a> </li>
        <li> <a href="#">Examples</a> </li>
        <li> <a href="#">Legal</a> </li>
      </ul>
    </nav>
  </header>
  <!-- 一个文档只允许存在一个不为hidden的main元素 -->
  <main>
    <!-- 文章元素，用于包含“完整独立的表达区域”，可以嵌套，例如文章和文章评论，一般来说
      当页面的主要内容（即不包括页脚、页眉、导航块和侧边栏）都是一个独立的组合时，这些内容可能会被标记为一篇文章-->
    <article>
      <!-- hgroup 用来分组标题，一个就不用分组了 -->
      <hgroup>
        <!-- h1-6 用来写文字或文章部分的标题-->
        <h1>HTML学习</h1>
        <h4>副标题</h4>
        <a href="https://html.spec.whatwg.org/multipage/indices.html#element-content-categories">原文链接</a>
      </hgroup>
      <section>
        <h2>abbr和dfn</h2>
        <!-- abbr 用于首字母缩写强调，给出释义，dfn用于术语定义或解释 -->
        <p><a href="#who"><abbr title="World Health Organization">WHO</abbr></a> 成立于 1948 年。</p>
        <p><dfn id="who" title="World Health Organization"><abbr title="World Health Organization">WHO</abbr></dfn> 世界卫生组织</p>
      </section>
      <section>
        <h2>blockquote cite figure figcaption</h2>
        <!-- figure 元素表示一些流内容，可选地带有标题，它是自包含的（如完整的句子），通常作为文档主要流中的单个单元引用。 -->
        <figure>
          <!--blockquote 应用其他来源的文章，cite元素可以用来写引用的地址或书名等等-->
          <blockquote>
            <p>The truth may be puzzling. It may take some work to grapple with.
              It may be counterintuitive. It may contradict deeply held
              prejudices. It may not be consonant with what we desperately want to
              be true. But our preferences do not determine what's true. We have a
              method, and that method helps us to reach not absolute truth, only
              asymptotic approaches to the truth — never there, just closer
              and closer, always finding vast new oceans of undiscovered<br>
              possibilities. Cleverly designed experiments are the key.</p>
          </blockquote>
          <!-- figure 元素的第一个 figcaption 元素子元素（如果有）表示图形元素内容的标题。如果没有子 figcaption 元素，则没有标题。 -->
          <!--cite 元素表示作品的名称等，不可用于人名 -->
          <figcaption>Carl Sagan, in "<cite>Wonder and Skepticism</cite>", from
            the <cite>Skeptical Inquirer</cite> Volume 19, Issue 1 (January-February
            1995)</figcaption>
        </figure>
      </section>
      <section>
        <h2>b strong blockquote i kbd samp mark code pre meter q ruby s wbr br hr span div</h2>
        <!-- hr 标识标题完成，并换行 -->
        <hr>
        <!--b 元素代表一段文本，出于实用目的而引起注意，但不传达任何额外的重要性，也没有暗示替代声音或情绪，
          例如文档摘要中的关键词、评论中的产品名称、可操作的词在交互式文本驱动软件中，或文章导览。-->
        <p>The <b>frobonitor</b> and <b>barbinator</b> components are fried.</p>
        <!-- 如果用于强调，请使用strong，strong元素代表其内容的重要性、严重性或紧迫性。
          可以在标题、标题或段落中使用 strong 元素来区分真正重要的部分和其他可能更详细、更愉快或仅仅是样板的部分。
        （这与标记副标题不同，hgroup 元素适合。）-->
        <p><strong>WARNING!</strong> Do not frob the barbinator!</p>
        <!-- em 用于重音强调，但不是表示重要性，更偏重于语言级别的强调，不是普通的斜体，如果斜体请使用i元素 -->
        <p><em>Cats</em> are <em>cute</em> animals.</p>
        <!-- i 元素代表一段文本，以另一种声音或情绪，或以其他方式偏离正常散文，
          以指示不同质量的文本，例如分类名称、技术术语、来自另一种语言的惯用短语、音译、思想或西方文本中的船名。
          所有经常用来放文中小图标-->
        <p>Raymond tried to sleep.</p>
        <p><i>The ship sailed away on Thursday</i>, he
          dreamt. <i>The ship had many people aboard, including a beautiful
            princess called Carey. He watched her, day-in, day-out, hoping she
            would notice him, but she never did.</i></p>
        <p><i>Finally one night he picked up the courage to speak with
            her—</i></p>
        <p>Raymond woke with a start as the fire alarm rang out.</p>
        <!-- ins 用于文档附加，旁白之类的 -->
        <p> I like fruit.
          <ins>
            Apples are <em>tasty</em>.
          </ins>
          <ins>
            So are pears.
          </ins>
        </p>
        <!-- kbd 元素表示用户输入（通常是键盘输入，但它也可用于表示其他输入，例如语音命令）。
          当 kbd 元素嵌套在 samp 元素中时，它表示系统响应的输入。
          当 kbd 元素包含 samp 元素时，它表示基于系统输出的输入，例如调用菜单项。
          当 kbd 元素嵌套在另一个 kbd 元素中时，它代表一个实际的键或其他适合输入机制的单个输入单元 -->
        <p>To make George eat an apple, press <kbd><kbd>Shift</kbd>+<kbd>F3</kbd></kbd></p>
        <p>To make George eat an apple, select
          <kbd><kbd><samp>File</samp></kbd>|<kbd><samp>Eat Apple...</samp></kbd></kbd>
        </p>
        <p>The computer said <samp>Too much cheese in tray
            two</samp> but I didn't know what that meant.
        </p>
        <!-- mark用于引起注意，高亮 -->
        <p lang="en-US">Consider the following quote:</p>
        <blockquote lang="en-GB">
          <p>Look around and you will find, no-one's really
            <mark>colour</mark> blind.</p>
        </blockquote>
        <p lang="en-US">As we can tell from the <em>spelling</em> of the word,
          the person writing this quote is clearly not American.
        </p>
        <p>The highlighted part below is where the error lies:</p>
        <!-- pre预定义格式文本，按照文档中本来的格式，code表示代码 -->
        <pre><code>var i: Integer;
begin
   i := <mark>1.1</mark>;
end.</code></pre>
        <!-- meter 测量仪 -->
        <dl>
          <dt>Radius:
          <dd> <meter min=0 max=20 value=12 title="centimeters">12cm</meter>
          <dt>Height:
          <dd> <meter min=0 max=10 value=2 title="centimeters">2cm</meter>
        </dl>
        <!-- 自动加引号，表示引用 -->
        <p>The W3C page <cite>About W3C</cite> says the W3C's
          mission is <q cite="https://www.w3.org/Consortium/">To lead the
            World Wide Web to its full potential by developing protocols and
            guidelines that ensure long-term growth for the Web</q>. I
          disagree with this mission.
        </p>
        <!-- ruby 用来注音等-->
        <ruby>
          <rb>英雄</rb>
          <rt>えいゆう</rt>
          <rp>(えいゆう)</rp>
        </ruby>
        <ruby>
          <rb>英雄</rb>
          <rt>ying xiong</rt>
          <!-- rp用于不支持ruby浏览器显示 -->
          <rp>(ying xiong)</rp>
        </ruby>
        <!-- s 标签用来表示不准确或不再相关的内容，和del表达含义不一样 -->
        <p>Buy our Iced Tea and Lemonade!</p>
        <p><s>Recommended retail price: $3.99 per bottle</s></p>
        <p><strong>Now selling for just $2.99 a bottle!</strong></p>
        <!-- 上标和下标 -->
        <p>The coordinate of the <var>i</var>th point is
          (<var>x<sub><var>i</var></sub></var>, <var>y<sub><var>i</var></sub></var>).
          For example, the 10th point has coordinate
          (<var>x<sub>10</sub></var>, <var>y<sub>10</sub></var>).
        </p>
        <p>Their names are
          <span lang="fr"><abbr>M<sup>lle</sup></abbr> Gwendoline</span> and
          <span lang="fr"><abbr>M<sup>me</sup></abbr> Denise</span>.
        </p>
        <!-- var 表示变量 虽然是斜体，但和强调不同-->
        <p>If there are <var>n</var> pipes leading to the ice
          cream factory then I expect at <em>least</em> <var>n</var>
          flavors of ice cream to be available for purchase!
        </p>
        <!-- wbr 换行 和 br换行的区别在于，wbr会根据容器宽度选择是否换行，若宽度不够则在wbr处换行-->
        <p>So then she pointed at the tiger and screamed <wbr>
          "there<wbr>is<wbr>no<wbr>way<wbr>you<wbr>are<wbr>ever<wbr>going<wbr>to<wbr>catch<wbr>me"!
          "there<wbr>is<wbr>no<wbr>way<wbr>you<wbr>are<wbr>ever<br>going<wbr>to<wbr>catch<wbr>me"!
        </p>
        <!-- u 元素表示一段文本，用于标识标记，提示错误，尽量不使用，和链接的展示有些冲突 -->
        <p>The <u>see</u> is full of fish.</p>
        <!-- span div 没有任何具体含义，span是inline元素 div是块元素-->
        <div>
          sd<span>sd</span>
          <div>sd</div>
        </div>
      </section>
      <section>
        <h2>bdi和bdo</h2>
        <!-- 双向算法渲染文本使用，阿拉伯语等，此元素可防止渲染混乱 -->
        <ul>
          <li>User <bdi>jcranmer</bdi>: 12 posts.</li>
          <li>User <bdi>hober</bdi>: 5 posts.</li>
          <li>User <bdi>إيان</bdi>: 3 posts.</li>
        </ul>
        <ul>
          <li>User <span>jcranmer</span>: 12 posts.</li>
          <li>User <span>hober</span>: 5 posts.</li>
          <li>User <span>إيان</span>: 3 posts.</li>
        </ul>
        <ul>
          <li>User <bdo dir="auto">jcranmer</bdo>: 12 posts.</li>
          <!--correct-->
          <li>User <bdo dir="ltr">hober</bdo>: 5 posts.</li>
          <!--correct-->
          <li>User <bdo dir="rtl">hober</bdo>: 5 posts.</li>
          <li>User <bdo dir="auto">إيان</bdo>: 3 posts.</li>
          <!--correct-->
          <li>User <bdo dir="ltr">إيان</bdo>: 3 posts.</li>
          <li>User <bdo dir="rtl">إيان</bdo>: 3 posts.</li>
          <li><bdo dir="rtl">User<span>إيان</span>: 3 posts.</bdo></li>
          <li><bdo dir="auto">User<span>إيان</span>: 3 posts.</bdo></li>
          <li><bdo dir="ltr">User<span>إيان</span>: 3 posts.</bdo></li>
        </ul>
      </section>
      <section>
        <h2>area map</h2>
        <p>
          请选择一块区域
          <img src="./images/sample-usemap.png" usemap="#shapes" alt="Four shapes are available: a red hollow box, a green circle, a blue triangle, and a yellow four-pointed star.">
        </p>
        <!-- area 标签位于map中，shape，coords共同定义了区域，shape为"default"时不应该有coords属性，默认整个区域 
          如果 href 属性不存在，则必须省略 target、download、ping、rel 和 referrerpolicy 属性。有href必须定义alt，有href属性
          代表可以点击区域，没有href则该区域无反应
          shape="rect" coords=左上角顶点坐标为(x1,y1)，右下角顶点坐标为(x2,y2)
          shape="circle" coords=圆心坐标为(x1,y1)，半径为r))
          shape="poly" coords=各顶点坐标依次为(x1,y1)、(x2,y2)、(x3,y3) ......
          -->
        <map id="shapes" name="shapes">
          <area shape="rect" coords="50,50,100,100"> <!-- the hole in the red box -->
          <area shape="rect" coords="25,25,125,125" href="red.html" alt="Red box.">
          <area shape="circle" coords="200,75,50" href="green.html" alt="Green circle.">
          <area shape="poly" coords="325,25,262,125,388,125" href="blue.html" alt="Blue triangle.">
          <area shape="poly" coords="450,25,435,60,400,75,435,90,450,125,465,90,500,75,465,60" href="yellow.html" alt="Yellow star.">
        </map>
      </section>
      <section>
        <h2>table</h2>
        <table border="1">
          <!-- 表格标题 -->
          <caption>
            <p>Table 1.</p>
            <p>This table shows ...</p>
          </caption>
          <!-- colgroup和col一般出现在表格当中，定义表格单独列的任意属性，col能覆盖colgroup定义的属性 -->
          <colgroup span="5" style="background-color:#666666; color: aliceblue;">
            <col style="background-color:#FFF">
            <col width="100px" style="color: #FFF; background-color: yellow; text-align: center;">
            <col span="3" width="200px" style="text-align: end;">
          </colgroup>
          <thead>
            <tr>
              <th>1</th>
              <th>2</th>
              <th>3.1</th>
              <th colspan="2">3.2</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>a</td>
              <td>b</td>
              <td>c</td>
              <td>d</td>
              <td>d2</td>
            </tr>
            <tr>
              <td>a1</td>
              <td><time>2011-11-18 14:54:39</time></td>
              <!--data tag 将一个指定内容和机器可读的翻译联系在一起。但是，如果内容是与时间或者日期相关,请使用time -->
              <td><data value="8">Eight</data></td>
              <script>
                console.log(document.getElementsByTagName('data')[0].value); // 8
              </script>
              <td>我在 <time datetime="2008-02-14">情人节</time> 有个约会</td>
              <script>
                console.log(document.getElementsByTagName('time')[1].dateTime); //2008-02-14
              </script>
              <td>d2</td>
            </tr>
          </tbody>
          <tfoot>
            <tr>
              <td colspan="5">hello world</td>
            </tr>
          </tfoot>
        </table>
      </section>
      <section>
        <h2>datalist</h2>
        <!-- datalist 元素代表一组选项元素，代表其他控件的预定义选项。在渲染中， datalist 元素不代表任何东西，它及其子元素应该被隐藏。 -->
        <!-- 可以通过两种方式使用 datalist 元素。在最简单的情况下，datalist 元素只有选项元素子元素。 -->
        <label>
          Animal:
          <input name="animal" list="animals">
          <datalist id="animals">
            <option value="Cat"></option>
            <option value="Dog"></option>
          </datalist>
        </label>
        <!-- 另一种方式可以用于不支持datalist的客户端 -->
        <label>
          Course:
          <input name="c" list="cs">
        </label>
        <datalist id="cs">
          <!-- select 元素表示用于在一组选项中进行选择的控件 -->
          <select name="c">
            <optgroup label="8.01 Physics I: Classical Mechanics">
              <option value="8.01.1">Lecture 01: Powers of Ten
              <option value="8.01.2">Lecture 02: 1D Kinematics
              <option value="8.01.3">Lecture 03: Vectors
            <optgroup label="8.02 Electricity and Magnetism">
              <option value="8.02.1">Lecture 01: What holds our world together?
              <option value="8.02.2">Lecture 02: Electric Field
              <option value="8.02.3">Lecture 03: Electric Flux
            <optgroup label="8.03 Physics III: Vibrations and Waves">
              <option value="8.03.1">Lecture 01: Periodic Phenomenon
              <option value="8.03.2">Lecture 02: Beats
              <option value="8.03.3">Lecture 03: Forced Oscillations with Damping
          </select>
        </datalist>
      </section>
      <section>
        <h2>组列表（dl）、无序列表（ul）、有序列表（ol）、菜单（menu）</h2>
        <!-- 组列表可以使用div作为子元素辅助设计样式 -->
        <dl>
          <dt><dfn>happiness</dfn></dt>
          <dd class="pronunciation">/ˈhæpinəs/</dd>
          <dd class="part-of-speech"><i><abbr>n.</abbr></i></dd>
          <dd>The state of being happy.</dd>
          <dd>Good fortune; success. <q>Oh <b>happiness</b>! It worked!</q></dd>
          <dt><dfn>rejoice</dfn></dt>
          <dd class="pronunciation">/rɪˈdʒɔɪs/</dd>
          <dd><i class="part-of-speech"><abbr>v.intr.</abbr></i> To be delighted oneself.</dd>
          <dd><i class="part-of-speech"><abbr>v.tr.</abbr></i> To cause one to be delighted.</dd>
        </dl>
        <dl>
          <div>
            <dt> Last modified time </dt>
            <dd> 2004-12-23T23:33Z </dd>
          </div>
          <div>
            <dt> Recommended update interval </dt>
            <dd> 60s </dd>
          </div>
          <div>
            <dt> Authors </dt>
            <dt> Editors </dt>
            <dd> Robert Rothman </dd>
            <dd> Daniel Jackson </dd>
          </div>
        </dl>
        <p>Things cats love:</p>
        <ul>
          <li>cat nip</li>
          <li>laser pointers</li>
          <li>lasagna</li>
        </ul>
        <p>Top 3 things cats hate:</p>
        <!-- li元素作为以下三个元素的子元素 -->
        <ol>
          <li>flea treatment</li>
          <li>thunder</li>
          <li>other cats</li>
        </ol>
        <h1>To Do</h1>
        <ul>
          <li>Empty the dishwasher</li>
          <!-- del表示删除 -->
          <li><del datetime="2009-10-11T01:25-07:00">Watch Walter Lewin's lectures</del></li>
          <li><del datetime="2009-10-10T23:38-07:00">Download more tracks</del></li>
          <li><del cite="article.html">Buy a printer</del></li>
        </ul>
        <menu>
          <li><button onclick="copy()"><img src="copy.svg" alt="Copy"></button></li>
          <li><button onclick="cut()"><img src="cut.svg" alt="Cut"></button></li>
          <li><button onclick="paste()"><img src="paste.svg" alt="Paste"></button></li>
        </menu>
      </section>
      <section>
        <h2>details summary progress</h2>
        <!-- details 用户可以控制是否展示详情，用来展示一些可隐藏细节的东西 -->
        <details>
          <summary>Copying... <progress max="375505392" value="97543282"></progress> 25%</summary>
          <dl>
            <dt>Transfer rate:</dt>
            <dd>452KB/s</dd>
            <dt>Local filename:</dt>
            <dd>/home/rpausch/raycd.m4v</dd>
            <dt>Remote filename:</dt>
            <dd>/var/www/lectures/raycd.m4v</dd>
            <dt>Duration:</dt>
            <dd>01:16:27</dd>
            <dt>Color profile:</dt>
            <dd>SD (6-1-6)</dd>
            <dt>Dimensions:</dt>
            <dd>320×240</dd>
          </dl>
        </details>
        <dialog>
          <h1>Add to Wallet</h1>
          <p><strong><label for=amt>How many gold coins do you want to add to your wallet?</label></strong></p>
          <p><input id=amt name=amt type=number min=0 step=0.01 value=100></p>
          <p><small>You add coins at your own risk.</small></p>
          <p><label><input name=round type=checkbox> Only add perfectly round coins </label></p>
          <p><input type=button onclick="submit()" value="Add Coins"></p>
          <button type="button" id="closedialog">close</button>
        </dialog>
        <!-- type 属性 submit reset button，默认是submit-->
        <button id="opendialog" type="button">open</button>
        <script>
          document.getElementById('opendialog').onclick = function() {
            document.getElementsByTagName('dialog')[0].showModal();
          };
          document.getElementById('closedialog').onclick = function() {
            document.getElementsByTagName('dialog')[0].close();
          };
        </script>
      </section>
      <section>
        <h2>slot template shadow dom</h2>
        <!-- 
          shadow dom，顾名思义，影子节点，它是 web components 规范的一个子集，主要为了解决dom对象的封装，
          通常的dom，其js行为和css样式极易受到别的代码的干扰，
          但shadow dom规定了只有其宿主才可定义其表现，外部的api是无法获取到shadow dom中的东西。
          template 可以将样式封装
          slot标签仅仅是一个占位符而已，其最终会被宿主标记了该位置的内容替换（注意是替换，而不是插入），因此没必要对slot标签设置样式，
          这就是为啥chrome 53忽略其样式的原因，无独有偶，最新版的ios 10默认浏览器也会隐藏slot，因为slot中并不需要显示任何东西。
         -->
        <div id="con">
          <p>没什么卵用的文字</p>
          <span slot="main1">
            坑位1
          </span>
          <span slot="main2">
            坑位2
          </span>
        </div>
        <template id="tpl">
          tpl begin
          <slot name="main1">
          </slot>
          <slot name="main2">
          </slot>
          tpl end
        </template>
        <script>
          var host = document.querySelector('#con');
          var root = host.attachShadow({
            mode: 'open'
          }); //为宿主附加一个影子元素
          var con = document.getElementById("tpl").content.cloneNode(true);
          root.appendChild(con);
          // root.innerHTML = "我来自shadow dom";
        </script>
        <template id="element-details-template">
          <style>
            details {
              font-family: "Open Sans Light", Helvetica, Arial
            }

            .name {
              font-weight: bold;
              color: #217ac0;
              font-size: 120%
            }

            h4 {
              margin: 10px 0 -8px 0;
            }

            h4 span {
              background: #217ac0;
              padding: 2px 6px 2px 6px
            }

            h4 span {
              border: 1px solid #cee9f9;
              border-radius: 4px
            }

            h4 span {
              color: white
            }

            .attributes {
              margin-left: 22px;
              font-size: 90%
            }

            .attributes p {
              margin-left: 16px;
              font-style: italic
            }
          </style>
          <details>
            <summary>
              <span>
                <code class="name">&lt;<slot name="element-name">NEED NAME</slot>&gt;</code>
                <i class="desc">
                  <slot name="description">NEED DESCRIPTION</slot>
                </i>
              </span>
            </summary>
            <div class="attributes">
              <h4><span>Attributes</span></h4>
              <slot name="attributes">
                <p>None</p>
              </slot>
            </div>
          </details>
          <hr>
        </template>

        <element-details>
          <span slot="element-name">slot</span>
          <span slot="description">A placeholder inside a web
            component that users can fill with their own markup,
            with the effect of composing different DOM trees
            together.</span>
          <dl slot="attributes">
            <dt>name</dt>
            <dd>The name of the slot.</dd>
          </dl>
        </element-details>

        <element-details>
          <span slot="element-name">template</span>
          <span slot="description">A mechanism for holding client-
            side content that is not to be rendered when a page is
            loaded but may subsequently be instantiated during
            runtime using JavaScript.</span>
        </element-details>
        <script>
          customElements.define('element-details',
            class extends HTMLElement {
              constructor() {
                super();
                const template = document
                  .getElementById('element-details-template')
                  .content;
                const shadowRoot = this.attachShadow({
                    mode: 'open'
                  })
                  .appendChild(template.cloneNode(true));
              }
            });
        </script>
      </section>
    </article>
    <section>
      <h2>fieldset form legend input output</h2>
      <!-- legend.form IDL 属性的行为取决于legend元素是否在 fieldset 元素中。
        如果图例将 fieldset 元素作为其父元素，则表单 IDL 属性必须返回与该 fieldset 元素上的表单 IDL 属性fieldset.form相同的值。
        否则，它返回 null。-->
      <form>
        <fieldset name="clubfields" disabled>
          <legend> <label>
              <input type=checkbox name=club onchange="console.log(form);form.clubfields.disabled = !checked">
              Use Club Card
            </label> </legend>
          <p><label>Name on card: <input name=clubname required></label></p>
          <fieldset name="numfields">
            <legend> <label>
                <input type=radio name=clubtype onblur="form.numfields.disabled = checked;console.log('blur',checked,form.numfields.disabled);" onchange="form.numfields.disabled = !checked;console.log(1,checked,form.numfields.disabled);">
                My card has numbers on it
              </label> </legend>
            <p><label>Card number: <input name="clubnum" required pattern="[-0-9]+"></label></p>
          </fieldset>
          <fieldset name="letfields" disabled>
            <legend> <label>
                <input type=radio name=clubtype onblur="form.letfields.disabled = checked;" onchange="form.letfields.disabled = !checked;console.log(2,checked,form.letfields.disabled);">
                My card has letters on it
              </label> </legend>
            <p><label>Card code: <input name="clublet" required pattern="[A-Za-z]+"></label></p>
          </fieldset>
        </fieldset>
      </form>
      <!-- output 用于输出计算结果 -->
      <form onsubmit="return false" oninput="o.value = a.valueAsNumber + b.valueAsNumber">
        <input id=a type=number step=any> +
        <input id=b type=number step=any> =
        <output id=o for="a b"></output>
      </form>
      <form action="https://www.freecatphotoapp.com/submit-cat-photo">
        <label for="indoor"><input id="indoor" type="radio" name="indoor-outdoor"> Indoor</label>
        <label for="outdoor"><input id="outdoor" type="radio" name="indoor-outdoor" value="outdoor"> Outdoor</label><br>
        <label for="loving"><input id="loving" type="checkbox" name="personality" value="loving"> Loving</label>
        <label for="lazy"><input id="lazy" type="checkbox" name="personality" value="lazy"> Lazy</label>
        <label for="energetic"><input id="energetic" type="checkbox" name="personality"> Energetic</label><br>
        <label><input type="color" name="color" />color</label><br>
        <label><input type="date" name="date" />date</label><br>
        <label><input type="datetime" name="datetime" />datetime</label><br>
        <label><input type="datetime-local" name="datetime-local" />datetime-local</label><br>
        <label><input type="email" name="email" />email</label><br>
        <label><input type="month" name="month" />month</label><br>
        <label><input type="number" name="number" />number</label><br>
        <label><input type="range" name="range" />range</label><br>
        <label><input type="search" name="search" />search</label><br>
        <label><input type="tel" name="tel" />tel</label><br>
        <label><input type="time" name="time" />time</label><br>
        <label><input type="url" name="url" />url</label><br>
        <label><input type="week" name="week" />week</label><br>
        <input type="text" placeholder="cat photo URL" required>
        <button type="submit">Submit</button>
      </form>
    </section>
    <article>
      <h1>内嵌外部资源</h1>
      <section>
        <h2>audio</h2>
        <audio controls>
          <source src="./resource/horse.mp3" type="audio/mpeg">
          您的浏览器不支持该音频格式。
        </audio>
      </section>
      <section>
        <h2>video</h2>
        <!-- video 用来播放视频文件，可以用source设置多种格式的文件，track用来播放字幕 -->
        <video width="320" height="240" controls="controls">
          <source src="forrest_gump.mp4" type="video/mp4" />
          <source src="forrest_gump.ogg" type="video/ogg" />
          <track kind="subtitles" src="subs_chi.srt" srclang="zh" label="Chinese">
          <track kind="subtitles" src="subs_eng.srt" srclang="en" label="English">
        </video>
      </section>
      <section>
        <h2>canvas</h2>
        <!-- 可编写脚本的位图画布 -->
        <canvas id="canvas"></canvas>
        <script>
          const canvas = document.getElementById('canvas');
          const ctx = canvas.getContext('2d');
          ctx.fillStyle = 'green';
          ctx.fillRect(10, 10, 150, 100);
        </script>
      </section>
      <section>
        <h2>embed object</h2>
        <embed src="images/relaxing-cat.jpg" type="image/jpeg">
        <embed height="100px" src="resource/horse.mp3" type="audio/mpeg">
        <object data="images/relaxing-cat.jpg" type="image/jpeg">
          <param name="n" value="v">
        </object>
      </section>
      <section>
        <h2>iframe</h2>
        <iframe src="./article.html" width="600px" height="300px"></iframe>
        <iframe width="600px" height="300px" sandbox srcdoc="<p>Yeah, you can see it <a href=&quot;/gallery?mode=cover&amp;amp;page=1&quot;>in my gallery</a>."></iframe>
      </section>
      <section>
        <h2>picture source</h2>
        <!-- picture 用于多种来源的img，source可以通过media属性来调整显示，source也可用于展示audio，video-->
        <picture>
          <source media="(min-width:650px)" srcset="images/flower-4.jpg">
          <source media="(min-width:465px)" srcset="images/tulip.jpg">
          <img src="images/flower.gif" alt="Flowers" style="width:auto;">
        </picture>
      </section>
    </article>
  </main>
  <!-- aside 表示页面的一部分，该部分由与aside元素周围的内容相切相关（或不相关）的内容组成，例如导航，广告等等 -->
  <aside>
    <nav>
      <h1>Archives</h1>
      <ol reversed>
        <li><a href="/last-post">My last post</a>
        <li><a href="/first-post">My first post</a>
      </ol>
    </nav>
    <article>
      <header>
        <h1>一则广告</h1>
        <section>
          <p>This is my first post.</p>
        </section>
        <section>
          <blockquote cite="https://twitter.example.net/t31351234">
            I'm on vacation, writing my blog.
          </blockquote>
          <blockquote cite="https://twitter.example.net/t31219752">
            I'm going to go on vacation soon.
          </blockquote>
        </section>
      </header>
    </article>
  </aside>
  <footer>
    <!-- 地址元素用于表示文档 article 或 body 联系信息， 地址元素不应该包含联系信息以外的信息-->
    <address>
      For more details, contact
      <a href="someone@example.com">some one</a>.
    </address>
    <!-- 小字体通常包含免责声明、警告、法律限制或版权。小字体有时也用于归属或满足许可要求。
      small 元素不会“淡化”或降低 em 元素强调的文本的重要性，也不会用 strong 元素标记为重要的文本。
      要将文本标记为不强调或不重要，只需不要分别用 em 或 strong 元素标记它。
      small 元素不应用于扩展的文本跨度，例如多个段落、列表或文本部分。
      它仅适用于短文本。
      小元素不得用于副标题；
      为此，请使用 hgroup 元素 -->
    <p><small>© copyright 2038 Example Corp.</small></p>
  </footer>

  <!-- D3 JS -->
  <!-- <script src="https://cdn.jsdelivr.net/npm/d3@7"></script> -->

</body>

</html>
```

