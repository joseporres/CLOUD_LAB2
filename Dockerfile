FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y openjdk-8-jdk wget && \
    wget https://archive.apache.org/dist/spark/spark-1.5.2/spark-1.5.2-bin-hadoop2.6.tgz && \
    tar -xzf spark-1.5.2-bin-hadoop2.6.tgz && \
    mv spark-1.5.2-bin-hadoop2.6 /spark && \
    rm spark-1.5.2-bin-hadoop2.6.tgz

ENV SPARK_HOME /spark
ENV PATH $PATH:$SPARK_HOME/bin

COPY WordCount.java /src/WordCount.java
WORKDIR /src

RUN mkdir -p /app/build && \
    javac -cp $(echo /spark/jars/*.jar | tr ' ' ':') /app/WordCount.java -d /app/build && \
    jar -cvf /app/WordCount.jar -C /app/build/ .


CMD ["/spark/bin/spark-submit", "--class", "WordCount", "--master", "local[*]", "WordCount.jar", "input_file.txt", "output_file.txt"]
