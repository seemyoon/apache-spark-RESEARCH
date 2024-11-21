FROM ubuntu:22.04

# Установка Java, Python, SSH и дополнительные настройки
RUN set -ex && \
apt-get update && \
apt-get install -y lsof openjdk-8-jre-headless openssh-server openssh-client python3 python3-pip && \
rm /bin/sh && \
ln -sv /bin/bash /bin/sh && \
echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
mkdir -p /tmp/workdir

# Загрузка Apache Spark и Hadoop
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz && \
 tar -xzf hadoop-3.3.4.tar.gz && \
 rm -f hadoop-3.3.4.tar.gz && \
 mv hadoop-3.3.4 /opt/hadoop
RUN wget https://archive.apache.org/dist/spark/spark-3.4.0/spark-3.4.0-bin-hadoop3.tgz && \
 tar -xzf spark-3.4.0-bin-hadoop3.tgz && \
 rm -f spark-3.4.0-bin-hadoop3.tgz && \
 mv spark-3.4.0-bin-hadoop3 /opt/spark

# Копирование скриптов и файлов конфигурации
COPY hadoop-conf/* /opt/hadoop/etc/hadoop/
COPY spark-conf/* /opt/spark/conf/
COPY script /opt/script
RUN chmod +x /opt/script/*

# Задание рабочей директории
WORKDIR /tmp/workdir

# Задание внешних хранилищ Docker
VOLUME /tmp/storage /exthome

# Установка переменной окружения JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
RUN echo $JAVA_HOME > /etc/java-home

# Установка корневых путей Spark, Hadoop и скриптов
ENV HADOOP_HOME /opt/hadoop
ENV SPARK_HOME /opt/spark
ENV SCRIPT_HOME /opt/script

# Установка путей конфигурации Spark and Hadoop
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop
ENV SPARK_CONF_DIR ${SPARK_HOME}/conf

# Установка путей поиска исполняемых файлов и библиотек
ENV PATH ${PATH}:${HADOOP_HOME}/bin:${SPARK_HOME}/bin
ENV LD_LIBRARY_PATH ${HADOOP_HOME}/lib/native:${JAVA_HOME}/jre/lib/amd64/server:${LD_LIBRARY_PATH}

# Генерация и настройка SSH ключей
RUN ssh-keygen -b 4096 -t rsa -q -N "" -f /root/.ssh/id_rsa 0>&- && \
 cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys && \
 chmod 600 /root/.ssh/id_rsa

EXPOSE 9870 8088 50070

# Запуск скрипта post-setup
RUN python3 /opt/script/post-setup.py

# Скрипт для запуска при старте контейнера
ENTRYPOINT /opt/script/startup.sh


