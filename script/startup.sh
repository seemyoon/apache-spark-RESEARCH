#!/bin/bash

echo "Run mode: $RUN_MODE"

start_ssh() {
    echo 'Starting SSH server...'
    service ssh start
}

start_hdfs() {
    if [[ ! -d /tmp/storage/nameNode/current ]]
    then
        echo 'Namenode not initialized, formatting...'
        $HADOOP_HOME/bin/hdfs namenode -format
        $HADOOP_HOME/bin/hdfs dfs -mkdir -p /user/root
    fi
    echo 'Starting HDFS...'
    $HADOOP_HOME/sbin/start-dfs.sh
}

start_yarn() {
    echo 'Starting YARN...'
    $HADOOP_HOME/sbin/start-yarn.sh
}

start_spark() {
    echo 'Starting Spark cluster...'
    $SPARK_HOME/sbin/start-all.sh
}

case $RUN_MODE in
yarn-master)
    start_ssh
    start_hdfs
    start_yarn
    sleep infinity
    ;;
master)
    start_ssh
    start_hdfs
    start_spark
    sleep infinity
    ;;
hdfs)
    start_ssh
    start_hdfs
    sleep infinity
    ;;
slave)
    start_ssh
    sleep infinity
    ;;
esac
