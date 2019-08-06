#!/bin/bash

echo 安装jdk开始

jdk=/usr/local/jdk

now_str=`date -d now +%Y%m%d%H%M%S`


#mv jdk 
if [ -d $jdk ]; then
   mv $jdk /usr/local/jdk_$now_str
fi

tar zxvf jdk-8u171-linux-x64.tar.gz > /dev/null
/bin/mv -f jdk1.8.0_171 $jdk

#ln java
if [ -f "/usr/bin/java" ]; then
   mv /usr/bin/java /usr/bin/java_$now_str
fi
ln -s $jdk/bin/java /usr/bin/java


#ln jps
if [ -f "/usr/bin/jps" ]; then
   mv /usr/bin/jps /usr/bin/jps_$now_str
fi
ln -s $jdk/bin/jps /usr/bin/jps


cat >> /etc/profile  << EFF

#add by jdk
########################################
JAVA_HOME=$jdk
export JAVA_HOME
PATH=\$JAVA_HOME/bin:\$PATH
export PATH
########################################

EFF

. /etc/profile

echo 安装jdk结束
