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

### Linux
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


