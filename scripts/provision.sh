#!/bin/bash

apt-get update
apt-get -y install software-properties-common
add-apt-repository ppa:ondrej/nginx
apt-get update
apt-get -y install \
    nginx-extras \
    nano \
    wget \
    git \
    unzip \
    less \
    curl

./install-sh2ju.sh

