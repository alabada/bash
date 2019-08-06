#!/bin/sh

TOMCAT_HOME=/usr/local/tomcat
case "$1" in
   start)

	pids=`ps aux|grep java|grep "$TOMCAT_HOME"|awk '{print $2}'`
        if [ -n "$pids" ]; then
                echo "tomcat正在运行中."
        else
		ulimit -SHn 65535
               su - tomcat -c "cd /no/where;export LANG=zh_CN.UTF-8;$TOMCAT_HOME/bin/startup.sh &"
	        sleep 2
	       	$0 status
        fi
        touch /var/lock/subsys/tomcat
   ;;
   stop)
             pids=`ps aux|grep java|grep "$TOMCAT_HOME"|awk '{print $2}'`
             if [ -n "$pids" ]; then
                    echo "执行tomcat自带的shutdown.sh"
                    su - tomcat -c "$TOMCAT_HOME/bin/shutdown.sh &"
             fi              
            closed=0
            sleep_time=1
             while [ $closed -eq 0 ]
              do
                  pids=`ps aux|grep java|grep "$TOMCAT_HOME"|awk '{print $2}'`
                  if [ -n "$pids" ]; then
                       echo "等待tomcat结束:$sleep_time,10秒后将强制关闭"
                       sleep_time=$((sleep_time+1))                        
                       if [ $sleep_time -gt 10 ];then
                           kill -9 $pids
                           echo "超过10秒，强制kill -9 tomcat"                            
                           closed=1
                       else
                           sleep 1
                       fi
                  else
                      closed=1
                  fi                  
              done
	     $0 status
   ;;
   restart)
        $0 stop
        $0 start
   ;;
   status)
	pids=`ps aux|grep java|grep "$TOMCAT_HOME"|awk '{print $2}'`
        if [ -n "$pids" ]; then
                echo "tomcat服务已启动."
        else
                echo "tomcat服务已停止."
        fi
   ;;
   *)
        echo $"Usage: $0 {start|stop|restart|status}"
        exit $?
   ;;
esac
