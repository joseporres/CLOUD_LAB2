FROM ubuntu:latest


ENV SPARK_VERSION 1.5.2
ENV HADOOP_VERSION 2.6
ENV PYTHON_VERSION 2.7
ENV SPARK_HOME /opt/spark


RUN apt-get update && \
    apt-get install -y openjdk-8-jdk wget python${PYTHON_VERSION} && \
    apt-get clean

RUN wget -qO- https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz | tar xz -C /opt && \
    mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} $SPARK_HOME && \
    rm -rf $SPARK_HOME/examples $SPARK_HOME/data && \
    chown -R root:root $SPARK_HOME && \
    chmod -R 755 $SPARK_HOME

ENV PATH $PATH:$SPARK_HOME/bin
ENV PYSPARK_PYTHON=python2.7

COPY WordCount.py /app/WordCount.py

WORKDIR /app

CMD ["spark-submit", "--class", "WordCount", "--master", "local[*]", "/app/WordCount.py", "/data/input_file.txt", "/data/output_file.txt"]