#/bin/bash
IP=172.16.0.5
docker pull wurstmeister/zookeeper
docker run -d --name zookeeper -p 2181:2181 -v /etc/localtime:/etc/localtime wurstmeister/zookeeper
docker pull wurstmeister/kafka
docker run -d --name kafka -p 9092:9092 -e KAFKA_BROKER_ID=0 -e KAFKA_ZOOKEEPER_CONNECT=$IP:2181 -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://$IP:9092 -e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 -t wurstmeister/kafka

