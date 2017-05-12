#!/bin/bash
sudo yum update -y
cd /tmp

# Next we'll install nginx to act as our reverse proxy and git because we'll need to checkout sources. We'll also install the Java JDK and configure the system to use it by default.
sudo yum install -y git nginx java-1.8.0-openjdk-devel aws-cli
sudo alternatives --config java


# If you need apache maven to build Java sources you can install it as follows:
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
mvn –v


# We'll need to add the Jenkins repository to available packages:
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install jenkins -y


# Let's start Jenkins up and make sure it starts every time we reboot:
sudo service jenkins start
sudo chkconfig --add jenkins


# OK. Jenkins is actually up and running at this point. We can verify this by accessing localhost on port 8080 with curl.
#curl http://localhost:8080
























sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo yum install -y git java-1.8.0-openjdk-devel aws-cli
sudo alternatives --config java

sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
mvn –v

cd ~
kafkaVer="kafka_2.11-0.10.2.0"
if [ ! -d /opt/$kafkaVer ]
then
    wget "http://apache.claz.org/kafka/0.10.2.0/$kafkaVer.tgz"
    tar -xvf $kafkaVer.tgz
    sudo mv $kafkaVer /opt
    cd /opt/$kafkaVer
    publicIP=$(curl -s "http://169.254.169.254/latest/meta-data/public-ipv4/")
    echo "public ip from meta-data: $publicIP"
    sudo sed -i "s|#advertised.listeners=PLAINTEXT:.*:9092|advertised.listeners=PLAINTEXT:\/\/$publicIP:9092|" config/server.properties
fi
(sudo bin/zookeeper-server-start.sh -daemon config/zookeeper.properties)
(sudo bin/kafka-server-start.sh config/server.properties)
cd /opt/$kafkaVer
(sudo bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic testTopic)

