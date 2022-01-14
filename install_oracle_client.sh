#!/bin/bash

base_pack=https://download.oracle.com/otn_software/linux/instantclient/1913000/instantclient-basic-linux.x64-19.13.0.0.0dbru-2.zip
sdk_package=https://download.oracle.com/otn_software/linux/instantclient/1913000/instantclient-sdk-linux.x64-19.13.0.0.0dbru-2.zip

oracle_client=/usr/local/oracle
filename=instantclient_19_13

oracle_pkg_path=$oracle_client/$filename
ld_library_path=\$LD_LIBRARY_PATH:$oracle_client/$filename

release=`cat /etc/*-release | grep "^NAME" | awk -F = '{print $2}' | awk -F \" '{print $2}' | awk '{print $1}'`
command=""
if [ $release == "Debian" ]; then
    command=apt
elif [ $release == "CentOS" ]; then 
    command=yum
else
    echo "unsupport release"
    exit 1
fi

if ! [ -x "$(command -v unzip)" ]; then $command -y install zip; fi

curl -# -O $base_pack
curl -# -O $sdk_package

unzip instantclient-basic-linux.x64-19.13.0.0.0dbru-2.zip -d .
unzip instantclient-sdk-linux.x64-19.13.0.0.0dbru-2.zip -d .

if ! [ -d $oracle_client ]; then mkdir $oracle_client; fi

cat > oci8.pc << EOF
prefix=$oracle_client/$filename
exec_prefix=$oracle_client/$filename
includedir=\${prefix}/sdk/include
libdir=\${exec_prefix}

Name: oci8
Description: Oracle Instant Client
Version: 19.13
Cflags: -I\${includedir}
Libs: -L\${libdir} -lclntsh
EOF

cp oci8.pc $filename/
if  [ -d $oracle_client/$filename ]; then rm  -rf $oracle_client/$filename;fi
mv $filename $oracle_client/

cat > /etc/ld.so.conf.d/oracle_instantclient_19_13.conf << EOF
$oracle_client/$filename
EOF

file=''
if [ -f "$HOME/.bashrc" ]; then
    file=~/.bashrc
else
    file=~/.profile
fi

if [ `grep -c "$oracle_pkg_path" $file` -eq 0 ]; then 
cat >> $file << EOF
export PKG_CONFIG_PATH=$oracle_pkg_path  # 解压后存放instance的目录。
EOF
fi

if [ `grep -c "$ld_library_path" $file` -eq 0 ]; then 
cat >> $file << EOF
export LD_LIBRARY_PATH=$ld_library_path
EOF
fi

source  $file

rm -f instantclient*.zip
