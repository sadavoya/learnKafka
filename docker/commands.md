# Commands for Setting Up Kafka in Linux
## Set up Kafka
### Use Conductor
* Easiest way
* Free - no CC needed
* Comes with a UI to speed up dev
* Only for personal usage / learning
#### Steps
1. Navigate to [Get Started with Conductor](https://www.conduktor.io/get-started)
2. Click "Try for Free"
3. Enter an email then click Start Free Trial
4. Either use an email and password or use Google or other Auth provider
5. Add account details
6. Name your <Organization>
7. Add collaborator emails (or skip it)
8. Once that's all done, close the "Playground is Here" popup and click My Playground on the left
9. Details are displayed such as boostrap Url, username etc
10. Click the Home dropdown (top left corner) and select Console
11. Near the top Right, you will either see My Playground or <Organization> Playground
12. If the latter, click it and select My Plaground instead

You are now ready to Kafka with a personal cluster in the cloud

## Set up Kafka in Zookeeper mode

### Linux (WSL)
* [Detailed Instructions](https://www.conduktor.io/kafka/how-to-install-apache-kafka-on-linux/)
0. Create a docker image based on Alpine
1. Install JDK v11
    * [Instructions for alpine](https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/generic-linux-install.html#alpine-linux-install-instruct)
    1. wget -O /etc/apk/keys/amazoncorretto.rsa.pub  https://apk.corretto.aws/amazoncorretto.rsa.pub
    2. echo "https://apk.corretto.aws/" >> /etc/apk/repositories
    3. apk update
    4. apk add amazon-corretto-11
2. Download Apache Kafka from [kafka.apache.org/downloads](https://kafka.apache.org/downloads) under Binary Downloads
    * Define an environment var `KAFKA_FILE_NAME` that is the name 
    ```
    wget https://downloads.apache.org/kafka/3.4.0/$KAFKA_FILE_NAME.tgz
    tar xzf $KAFKA_FILE_NAME.tgz
    rm $KAFKA_FILE_NAME.tgz
    ```
3. Extract the contents on Linux
4. Setup the $PATH env vars for easy access to the Kafka binaries



## Set up Kafka in KRaft mode
### Linux (WSL)
* [Detailed Instructions](https://www.conduktor.io/kafka/how-to-install-apache-kafka-on-linux-without-zookeeper-kraft-mode)


# Running in docker
* Start our container: and get a bash prompt from within the container:
```
docker-compose up -d
```
* For kafka we need multiple terminals (one to run a local server, one for each console producer, and one for each console consumer). 
    * For each terminal needed, open a WSL prompt and then run:
        ```
        docker exec -ti kafka-kraft /bin/bash
        ```

* Stop our container and remove the image:
```
docker-compose down; docker rmi sadavoya/learn-kafka
```
* Commands inside the docker container:

    * If you cannot run `kafka-topics.sh` from the command line, you need to update the path:
    1. First, get the correct path from the .profile:
    `cat ~/.profile` then look for the line starting with `export PATH=`. It should look similar to this:
        ```
        export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/kafka_2.    13-3.4.0/bin"
        ```
    2. Copy that entire line, then paste at the command prompt and execute. 
    3. Test by running `kafka-topics.sh` - you should see output, not an error that the file could not be found

# Kafka commands
* Ensure we have the playground.config file create and populated with data from conductor
## Topic CRuD (Create, Read, and Delete - there is no Update)
* The following commands all start with a prefix that you can paste in first.
    * `{prefix}` for remote cluster (e.g. on Conductor):
        ```
        kafka-topics.sh --command-config /home/xfer/playground.config --bootstrap-server cluster.playground.cdkt.io:9092
        ```
    * `{prefix}` for local cluster (e.g. local machine or within a docker container):
        ```
        kafka-topics.sh --bootstrap-server localhost:9092
        ```
* Create a topic: `{prefix}` **`--create --topic my_first_topic`**
    * Create a topic with 5 partitions: 
        `{create a topic}` **`--partitions 5`**
    * Create a topic with an RF (Replication Factor) of 2:
        `{create a topic}`  **`--replication-factor 2`**
        * `Conductor` note: all topics have a MINIMUM RF of **3**
* Get details about a topic:
    `{prefix} --topic <topic name>` **`--describe`**
* List topics: `{prefix}` **`--list`**
* Delete a topic: `{prefix} --topic <topic name>` **`--delete`**

## Producer Commands
* The following commands all start with a prefix that you can paste in first
    * `{prefix}` (remote cluster): 
        ```
        kafka-console-producer.sh --producer.config /home/xfer/playground.config --bootstrap-server cluster.playground.cdkt.io:9092
        ```
    * `{prefix}` (local cluster): 
        ```
        kafka-console-producer.sh --bootstrap-server localhost:9092
        ```
* To start sending messages: `{prefix}` **`--topic <topic name>`**
    * A prompt will be displayed. Each line entered will be added to the topic.
    * If no such topic exists named `<topic name>` then either
        * the attempt to send will fail with an error OR
        * the attempt will cause the new topic to be created (depends on cluster settings)
* Enhancement example - get acknowledgement from leader and all replicas:
    `{prefix} --topic <topic name>` **`--producer-property acks=all`**

* To start sending messages that include a key: `{prefix} --topic <topic name>` **`--property parse.key=true --property key.separator=<separator character>`** 
    * A prompt will be displayed. Each line entered will be added to the topic. Each line will first be split into 2 values - the part before the `<separator character>`, and the part after. The first part will be the key for the message, while the second part will be the value.
        * Any line without the `<separator character>` will throw

## Consumer Commands
* The following commands all start with a prefix that you can paste in first
    * `{prefix}` (remote cluster): 
        ```
        kafka-console-consumer.sh --consumer.config /home/xfer/playground.config --bootstrap-server cluster.playground.cdkt.io:9092
        ```
    * `{prefix}` (local cluster): 
        ```
        kafka-console-consumer.sh --bootstrap-server localhost:9092
        ```
* Consume a topic: `{prefix}` **`--topic <topic name>`**
    * Now use a producer to send messages to the topic
    * As messages are sent, they will be displayed by the consumer
* Consume a topic from the beginning: `{prefix} --topic <topic name>` **`--from-beginning`**
    * All messages ever sent to the topic will be displayed
* Consume a topic from beginning and display key, value, timestamp, and partition:
    `{prefix} --topic <topic name>` **`--formatter kafka.tools.DefaultMessageFormatter --property print.timestamp=true`** `--property` **`print.key=true`** `--property` **`print.value=true`** `--property` **`print.partition=true`** `--from-beginning`

## Consumer Commands - groups
* Assume our `{basic}` consumer command is:
    `{prefix} --topic <topic name>`
* Start a consumer in a group:
    `{basic}` **`--group <application name>`**
    * start as many consumers in the same group as you like
    * as consumers are added or removed, they are rebalanced automatically to spread partitions as evenly as possible
    * when a consumer is added in a group, that consumer will catch up on any missed messages

## Consumer Group Commands
* Manipulate consumer groups
    * `{prefix}` (remote cluster): 
        ```
        kafka-consumer-groups.sh --command-config /home/xfer/playground.config --bootstrap-server cluster.playground.cdkt.io:9092
        ```
    * `{prefix}` (local cluster): 
        ```
        kafka-consumer-groups.sh --bootstrap-server localhost:9092
        ```
* List consumer groups: `{prefix}` **`--list`**
    * Consumers that were created **without a group** will show up briefly, but they are temporary groups that will be deleted automatically
* Describe a group: `{prefix}` **`--describe --group <group name>`**
    * Description includes two interesting properties:
        * Lag - indicates how many messages this consumer has missed (in its partition)
        * Consumer-ID shows the ID of the consumer so we can see which consumer is assigned to each partition
