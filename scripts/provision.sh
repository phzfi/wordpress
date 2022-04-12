#!/bin/sh

apt-get update
apt-get -y install software-properties-common
add-apt-repository ppa:ondrej/nginx
apt-get update
apt-get -y install \
    nginx-extras \
    nano \
    less \
    git \
    wget \
    curl \
    bc # required by sh2ju

# Install sh2ju, a JUnit compliant test framework for Bash
# See http://manolocarrasco.blogspot.fi/2010/02/hudson-publish-bach.html
git -C /usr/src clone https://github.com/manolo/shell2junit.git
