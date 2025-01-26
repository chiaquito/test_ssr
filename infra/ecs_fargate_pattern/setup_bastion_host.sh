#!/bin/bash


# Install git
dnf upgrade --releasever=latest
dnf -y install git 


# Install mysql client to confirm weather this machine can connect to database server
dnf -y install https://dev.mysql.com/get/mysql84-community-release-el9-1.noarch.rpm
dnf -y install mysql mysql-community-client
