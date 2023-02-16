FROM alpine

# Install Java
RUN wget -O /etc/apk/keys/amazoncorretto.rsa.pub  https://apk.corretto.aws/amazoncorretto.rsa.pub
RUN echo "https://apk.corretto.aws/" >> /etc/apk/repositories
RUN apk update
RUN apk add amazon-corretto-11

# Install bash
RUN apk add bash

# Install Kafka
ARG KAFKA_FOLDER=kafka_2.13-3.4.0
ARG KAFKA_FILE_NAME=$KAFKA_FOLDER.tgz
WORKDIR /home
RUN wget https://downloads.apache.org/kafka/3.4.0/$KAFKA_FILE_NAME
RUN tar xzf $KAFKA_FILE_NAME
RUN rm $KAFKA_FILE_NAME

# Add start script
RUN export PATH="$PATH:~/$KAFKA_FOLDER/bin"
RUN echo "#! /bin/sh" > /home/start_kafka.sh
RUN echo "echo Starting KRAFT" >> /home/start_kafka.sh
RUN echo "/home/$KAFKA_FOLDER/bin/kafka-storage.sh random-uuid | xargs -I{uuid} /home/$KAFKA_FOLDER/bin/kafka-storage.sh format -t {uuid} -c /home/$KAFKA_FOLDER/config/kraft/server.properties" >> /home/start_kafka.sh
RUN echo "/home/$KAFKA_FOLDER/bin/kafka-server-start.sh /home/$KAFKA_FOLDER/config/kraft/server.properties" >> /home/start_kafka.sh
RUN echo "echo KRAFT Started" >> /home/start_kafka.sh
RUN chmod +x /home/start_kafka.sh


# Volumes: 
# Kafka
# - /tmp/kafka-logs
# Zookeeper
# - /tmp/zookeeper