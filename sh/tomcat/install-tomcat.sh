#!/bin/sh

echo 安装tomcat开始

groupadd tomcat
useradd -g tomcat tomcat

install_dir=/usr/local/tomcat
service_name=tomcat
tomcat_version=7.0.6
tar_filename="apache-tomcat-$tomcat_version.tar.gz"
ext_folder="apache-tomcat-$tomcat_version"

oldPath=`pwd`

tar -zvxf $tar_filename >/dev/null 2>&1
mkdir -p $install_dir

cp -rf $ext_folder/* $install_dir
rm -rf $install_dir/webapps/*
rm $ext_folder -rf

chown tomcat.tomcat $install_dir -R

cp tomcat_service.sh /etc/init.d/$service_name
chmod +x /etc/init.d/$service_name
chkconfig --del $service_name
chkconfig --add $service_name

iptables -I INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
service iptables save
service iptables restart

echo 安装tomcat完成，服务名:$service_name
