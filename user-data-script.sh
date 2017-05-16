#!/bin/bash
sudo yum update -y
cd /tmp

# Next we'll install nginx to act as our reverse proxy and git because we'll need to checkout sources. We'll also install the Java JDK and configure the system to use it by default.
sudo rpm -e java-1.7.0-openjdk-1.7.0.131-2.6.9.0.71.amzn1.x86_64
sudo yum install -y git java-1.8.0-openjdk-devel aws-cli

#sudo alternatives --config java

echo 'export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk' | sudo tee -a /etc/profile
echo 'export JRE_HOME=/usr/lib/jvm/jre' | sudo tee -a /etc/profile
source /etc/profile

# If you need apache maven to build Java sources you can install it as follows:
#sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
#sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
#sudo yum install -y apache-maven
#mvn –v


# We'll need to add the Jenkins repository to available packages:
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install jenkins -y


# Let's start Jenkins up and make sure it starts every time we reboot:
sudo service jenkins start
sudo rpm -e java-1.7.0-openjdk-1.7.0.131-2.6.9.0.71.amzn1.x86_64
sudo service jenkins restart
sudo chkconfig --add jenkins
initialPW=$(sudo cat /var/lib/jenkins/secrets/IntialAdminPassword)
java -jar jenkins-cli.jar -s http://localhost:8080 who-am-i --username admin --password $initialPW


# OK. Jenkins is actually up and running at this point. We can verify this by accessing localhost on port 8080 with curl.
#curl http://localhost:8080

# Install Docker so we can run maven on the docker
sudo yum install -y docker
sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker jenkins
sudo service docker start

# Make Docker File that will be the Terraform Image
cd ~
cat << EOF > Dockerfile
FROM golang:alpine 
MAINTAINER "HashiCorp Terraform Team <terraform@hashicorp.com>"
ENV TERRAFORM_VERSION=0.9.5 
RUN apk add --update git bash openssh
ENV TF_DEV=true 
WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ && \
    git checkout v\${TERRAFORM_VERSION} && \
    /bin/bash scripts/build.sh
WORKDIR \$GOPATH
EOF
# Build The image. dot means look for the docker file.
docker build -t tf:latest .



