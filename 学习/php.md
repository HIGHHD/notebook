# PHP-FPM

PHP-FPM(PHP FastCGI Process Manager)意：PHP FastCGI 进程管理器，用于管理PHP 进程池的软件，用于接受web服务器的请求。
PHP-FPM提供了更好的PHP进程管理方式，可以有效控制内存和进程、可以平滑重载PHP配置。

(1). 为什么会出现php-fpm

fpm的出现全部因为php-fastcgi出现。为了很好的管理php-fastcgi而实现的一个程序

(2). 什么是php-fastcgi

php-fastcgi 只是一个cgi程序,只会解析php请求，并且返回结果，不会管理(因此才出现的php-fpm)。

(3)为什么不叫php-cgi

其实在php-fastcgi出现之前是有一个php-cgi存在的,只是它的执行效率低下，因此被php-fastcgi取代。

(4)那fastcgi和cgi有什么区别呢？

亲们，这区别就大了，当一个服务web-server(nginx)分发过来请求的时候，通过匹配后缀知道该请求是个动态的php请求，会把这个请求转给php。

在cgi的年代，思想比较保守，总是一个请求过来后,去读取php.ini里的基础配置信息，初始化执行环境，每次都要不停的去创建一个进程,读取配置，初始化环境，返回数据，退出进程，久而久之，启动进程的工作变的乏味无趣特别累。

当php来到了5的时代，大家对这种工作方式特别反感，想偷懒的人就拼命的想，我可不可以让cgi一次启动一个主进程(master),让他只读取一次配置，然后在启动多个工作进程(worker),当一个请求来的时候，通过master传递给worker这样就可以避免重复劳动了。于是就产生了fastcgi。

(5)fastcgi这么好，启动的worker用完怎么办？
当worker不够的时候，master会通过配置里的信息，动态启动worker，等空闲的时候可以收回worker

(6)到现在还是没明白php-fpm 是个什么东西?
就是来管理启动一个master进程和多个worker进程的程序.PHP-FPM 会创建一个主进程，控制何时以及如何将HTTP请求转发给一个或多个子进程处理。

PHP-FPM主进程还控制着什么时候创建(处理Web应用更多的流量)和销毁(子进程运行时间太久或不再需要了)*PHP子进程。PHP-FPM进程池中的每个进程存在的时间都比单个HTTP请求长,可以处*

*理10、50、100、500或更多的HTTP请求。*



```
php -i 获取详细配置
php --ini 获取php-fpm相关配置文件路径
```

