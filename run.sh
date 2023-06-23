#!/bin/sh

NAME=swagger-0.0.1-SNAPSHOT
APP_DIR=/opt/digital-accelerator
LOG_DIR=./logs
JAR=${APP_DIR}/${NAME}.jar




#CMD="java -Dserver.port=8081 -Dtomcat.ajp.port=8091 -Dlog4j2.formatMsgNoLookups=true -Dspring.config.location=classpath:application.properties,classpath:config.properties -Djava.net.preferIPv6Addresses=true  -Dsun.net.maxDatagramSockets=1024 -Dopentracing.jaeger.http-sender.url=http://uhn-hm-fores201a:80/api/traces -Dopentracing.jaeger.enabled=TRUE -Dopentracing.jaeger.log-spans=true -Dopentracing.jaeger.service-name=App-Server-201-A1 -XX:MaxPermSize=2000m -Xms5g -Xmx18g -XX:ParallelGCThreads=8 -XX:+UseConcMarkSweepGC -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:CMSInitiatingOccupancyFraction=50 -Xloggc:logs/gc.log-`date +'%Y%m%d%H%M'` -javaagent:./newrelic/newrelic.jar -Dnewrelic.tempdir=newrelic/tempdir -cp $APP_DIR/digi-acc-app.jar:$APP_DIR/lib/*:.  com.inn.AppRunner "

CMD="java -jar swagger-0.0.1-SNAPSHOT.jar"

LOG_FILE="$LOG_DIR/$NAME.log"
STDERR_LOG="$LOG_DIR/$NAME.err"
PID_FILE="$LOG_DIR/$NAME.pid"

#make the log directory if it doesn't exist
if [ ! -d "$LOG_DIR" ] ; then
	mkdir -p $LOG_DIR
	chmod 755 -R $LOG_DIR
fi

isRunning() {
	[ -f "$PID_FILE" ] && ps `cat $PID_FILE` > /dev/null 2>&1
}

case $1 in
	start)
		if isRunning; then
			echo "Already started"
		else
			echo "Starting $NAME"
			#sudo -u "$USER" $CMD > "$LOG_FILE" 2> "$STDERR_LOG" & echo $! > "$PID_FILE"
			$CMD > "$LOG_FILE" 2> "$STDERR_LOG" & echo $! > "$PID_FILE"
			if ! isRunning; then
				echo "Unable to start, see $LOG_FILE and $stderr_log"
				exit 1
			fi
		fi
	;;
	stop)
		if isRunning; then
			echo "Stopping $NAME"
			#sudo -u "$USER" kill `cat $PID_FILE`
			kill `cat $PID_FILE`
			rm "$PID_FILE"
		else
			echo "Not running"
		fi
	;;
	restart)
		sh $0 stop
		sh $0 start
	;;
	status)
		if isRunning; then
			echo "Running"
		else
			echo "Not running"
		fi
	;;
	*)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
    ;;
esac

exit 0
