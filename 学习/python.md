## pip

常用命令

```shell
pip freeze > requirements.txt   将当前已安装的pip包按requirements格式输出到文件
pip download -r requirements.txt -d /home/wheels  将已安装的pip包下载到目录
pip install --no-index --find-links=/home/wheels -r requirements.txt 离线安装
```



> wheels [Python Extension Packages for Windows - Christoph Gohlke (uci.edu)](https://www.lfd.uci.edu/~gohlke/pythonlibs/#ta-lib)

