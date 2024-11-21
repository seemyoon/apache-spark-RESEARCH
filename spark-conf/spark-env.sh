# Python interpreter for Spark to use
export PYSPARK_PYTHON="python3"

# Hostname of Spark master node
export SPARK_MASTER_HOST="yk-master"

# Spark SSH options for connecting to slave nodes
export SPARK_SSH_OPTS="-o StrictHostKeyChecking=no"

export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"