#!/bin/sh

mkdir -p etc/

apt-get update
add-apt-repository ppa:ondrej/php
apt-get -y install \
    ssmtp \
    php8.3-fpm \
    php8.3-cli \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-tidy \
    php-memcache \
    php-apcu \
    php-pear \
    php-imap \
    php-intl \
    php-ssh2 \
    php-zip \
    php-xml \
    php-xmlrpc
