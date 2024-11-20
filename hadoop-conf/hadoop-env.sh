#!/usr/bin/env bash

# Read JAVA_HOME path from file
export JAVA_HOME=$(cat /etc/java-home)

# Set OS type Hadoop is running on
export HADOOP_OS_TYPE=${HADOOP_OS_TYPE:-$(uname -s)}

# Hadoop SSH options for connecting to slave nodes
export HADOOP_SSH_OPTS="-o StrictHostKeyChecking=no"

# Hadoop working username config
export HDFS_NAMENODE_USER="root"
export HDFS_DATANODE_USER="root"
export HDFS_SECONDARYNAMENODE_USER="root"
export YARN_RESOURCEMANAGER_USER="root"
export YARN_NODEMANAGER_USER="root"
