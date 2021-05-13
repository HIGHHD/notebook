```
 nginx -c /home/api-workspace/sc-api/nginx-conf/nginx.conf

node 安装
https://nodejs.org/en/download/

wget https://nodejs.org/dist/v12.18.2/node-v12.18.2-linux-x64.tar.xz
tar -xvf node-v12.18.2-linux-x64.tar.xz

cd node-v12.18.2-linux-x64/bin

./npm install -g npm
./npm install -g n
n lts
n
选择需要的版本

npm install cnpm -g

redash 前端
git clone https://github.com/getredash/redash.git

cd redash

cnpm i

REDASH_BACKEND="http://192.168.202.59:5000" DEV_SERVER_HOST="192.168.202.159" npm run start

# 汉化

"angular-translate": "^2.18.3",
\client\app\config\index.js           import 'angular-translate';
			'pascalprecht.translate'

pip install -U PyYAML
sed -i 's/ipaddress.ip_address(text_type(ip_address)).is_private/False/g'  redash/query_runner/json_ds.py
sed -i 's/parse_boolean(os.environ.get("REDASH_ALLOW_SCRIPTS_IN_USER_INPUT", "false"))/parse_boolean(os.environ.get("REDASH_ALLOW_SCRIPTS_IN_USER_INPUT", "true"))/g'  redash/settings/__init__.py
sed -i 's/params = yaml.safe_load(query)/params = yaml.load(query, Loader=yaml.FullLoader)/g'  redash/query_runner/json_ds.py

sed -i 's/r=e.trustAsHtml(r)/r=e.trustAsHtml(String(n))/g' client/dist/app.88ac1b6c8e87b2093dc8.js

docker restart $(docker ps |grep redash/redash|awk '{print $1}')

docker stop $(docker ps|grep redash | awk '{print $1}')


redash docker 镜像搭建

由于以前多次构建
npm run build 出现大量报错 分别在根目录和viz-lib目录下执行 npm cache verify 和 npm install --cache /tmp/empty-cache 后 重新build

```

