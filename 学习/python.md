## 安装

```
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel
./configure --prefix=/usr/local/python3/ --enable-optimizations
make
make install
```

```
vi ~/.bashrc
PYTHON3=/usr/local/python3/bin
export PATH=$PYTHON3:$PATH
```



## pip

常用命令

```shell
pip freeze > requirements.txt   将当前已安装的pip包按requirements格式输出到文件
pip download -r requirements.txt -d /home/wheels  将已安装的pip包下载到目录
pip install --no-index --find-links=/home/wheels -r requirements.txt 离线安装
```



> wheels [Python Extension Packages for Windows - Christoph Gohlke (uci.edu)](https://www.lfd.uci.edu/~gohlke/pythonlibs/#ta-lib)

