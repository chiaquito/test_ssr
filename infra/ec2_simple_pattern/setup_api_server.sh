#!/bin/bash


# install git
dnf upgrade --releasever=latest
dnf -y install git 


# install mysql client to confirm weather this machine can connect to database server
dnf -y install https://dev.mysql.com/get/mysql84-community-release-el9-1.noarch.rpm
dnf -y install mysql mysql-community-client


# install golang runtime, go1.23.4
wget https://go.dev/dl/go1.23.4.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz
## add golang runtime path
echo PATH=$PATH:/usr/local/go/bin >> /home/ec2-user/.bash_profile;
source /home/ec2-user/.bash_profile



# server-code
# git clone https://github.com/chiaquito/shozai_model1.git
# cd shozai_model1
# go mod init shozai_model1
# go mod tidy

## 以下手動で設定
# 環境変数を設定
# export DB_HOST="hoge"
# export DB_USER="tfvarsの値"
# export DB_PASSWORD="tfvarsの値"
# go build -o ./tmp/main .
# ./tmp/main