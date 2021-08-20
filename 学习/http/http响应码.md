> [http状态码是什么意思 - http状态码大全 - php中文网手册](https://www.php.cn/web/web-http.html)

## 一、HTTP的正确响应码

1xx：请求已经被接收到了，需要进一步处理才能完成，HTTP1.0不支持

- 100 Continue 上传大文件前先让服务器准备，由客户端发起请求中携带Except：100-continue 头部触发
- 101 Switch Protocols协议升级使用，由客户端发起的请求中携带Upgrade头部，如升级WebSocket/http2.0
- 102 Processing WebDev请求可能包含许多涉及文件操作的子请求，等待很长时间才能完成子请求，该代码表示服务器已经收到并正在处理请求，但无响应可用，这样可以防止客户端超时，并假设请求丢失

2xx：成功处理请求

- 200 OK：成功返回响应
- 201 Created：有新资源在服务器端被成功创建
- 202 Accept：服务器接收并开始处理请求，但请求未处理完成，这样一个模糊的概念是有意如此设计，可以覆盖更多的场景。例如异步，需要长时间处理的任务
- 203 Non-Authoritative Information：当代理服务器修改了origin-serve的原始响应包体时(例如更换了HTML中的元素值)，代理服务器可以通过修改200为203的方式告知客户端这一事实，方便客户端为这一行为作出相应的处理，203响应可以被缓存
- 204 No Content：成功执行了请求且不携带响应包体，并暗示客户端无需更新当前的页面视图
- 205 Reset Content：成功执行了请求且不携带响应包体，同时指明客户端需要更新当前页面视图
- 206 Partial Content：使用Range协议时返回部分响应内容时的响应码(多线程断点下载)
- 207 Multi-Status：RFC4918 在WebDev协议中以XML返回多个资源的状态
- 208 Already Reported：RFC5842 ，为避免相同集合下资源在207响应码下重复上报，使用208可以使用父集合的响应码

3xx：重定向使用Location指向的资源或者缓存中的资源。在RFC2068中规定客户端的重定向次数不应该超过5次，以防止死循环

- 300 Multiple Choices：资源有多种表述，通过300返回给客户端后由其自行选择访问哪一种表述。由于缺乏明确的细节，300很少使用
- 301 Moved Permanently：资源永久性的重定向到另一个URI中(浏览器可以缓存)，它表示原 URL 不应再被使用，而应该优先选用新的 URL。搜索引擎机器人会在遇到该状态码时触发更新操作，在其索引库中修改与该资源相关的 URL 。
- 302 Found：资源临时的重定向到另一个URI中，CAS等SSO解决方案，一般都使用这个状态码重定向
- 303 See Other：重定向的其它资源，常用于post/put等方法的响应中
- 304 Not Modified：当客户端拥有可能过期的缓存时，会携带缓存的标识etag、时间等信息询问服务器缓存是否仍可复用，该状态码表示缓存值依然有效，可以使用。
- 307 Temporary Redirect：类似302 ，但明确重定向后请求方法必须与原请求方法相同，不得改变
- 308 Permanent Redirect：类似301，但明确重定向后请求方法必须与原请求方法相同，不得改变

## 二、HTTP的错误响应码

4xx：客户端出现错误

- 400 Bad Request：服务器认为客户端出现了错误，但不能明确判断为以下哪种错误时使用此错误码。例如HTTP请求格式错误
- 401 Unauthorized：用户认证信息缺失或者不正确，导致服务器无法处理请求
- 407 Proxy Authentication Required：对需要经由代理的请求，认证信息未通过代理服务器的验证
- 403 Forbidden：服务器理解请求的含义，但没有权限执行此请求，比如请求某个服务端目录下的音视频资源
- 404 Not Found：服务器没有找到对应的资源
- 410 Gone：服务器没有找到对应的资源，且明确的知道该位置永久性找不到该资源
- 405 Method Not Allowed：服务器不支持请求行中的method方法
- 406 Not Acceptable：对客户端指定的资源表述不存在(例如对语言或者编码有要求)，服务器返回列表供客户端选择
- 408 Request Timeout：服务器接收请求超时
- 409 Conflict：资源冲突，例如上传文件时目标位置已经存在版本更新的资源
- 411 Length Required：如果请求包含有包体且未携带Content-Length头部，且不属于chunk类请求时，返回411
- 412 Precondition Failed：复用缓存时传递的If-Unmodified-Since或If-None-Match头部不被满足
- 413 Payload Too Large/Request Entity Too Large：请求的包体超出服务器能处理的最大长度
- 414 URI Too Long：请求的URI超出服务器能接受的最大长度
- 415 Unsupported Media Type：上传的文件类型不被服务器支持
- 416 Range Not Satisfiable：无法提供Range请求中指定的那段包体
- 417 Expectation Failed：对于Expect 请求头部期待的情况无法满足时的响应码
- 421 Misdirected Request：服务器认为这个请求不该发送给它，因为它没有能力处理
- 426 Upgrade Required：服务器拒绝基于当前HTTP协议提供服务，用过Upgrade头部告知客户端必须升级协议才能继续处理
- 428 Precondition Required：用户请求中缺失了条件类头部，例如If-match
- 429 Too Many Requests：客户端发送请求的速率过快
- 431 Request Header Field Too Large：请求的HEADER 头部大小超过限制
- 451 Unavailable For Legal Reasons：RFC7725，由于法律原因资源不可访问

5xx：服务器端出现错误

- 500 Internal Server Error：服务器内部错误，且不属于以下错误类型
- 501 Not Implemented：服务器不支持实现请求所需要的功能
- 502 Bad Gateway：代理服务器无法获取到合法响应
- 503 Service Unavailable：服务器资源尚未准备好处理当前请求(例如服务端限流)
- 504 Gateway Timeout：代理服务器无法及时的从上游获得响应
- 505 HTTP Version Not Support：请求使用的HTTP协议版本不支持
- 507 Insufficient Storage：服务器没有足够的空间处理请求
- 508 Loop Detected：访问资源时检测到循环
- 511 Network Authentication Required：代理服务器发现客户端需要进行身份验证才能获得网络访问权限