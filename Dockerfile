FROM phzfi/ubuntu32:bionic-latest

ADD scripts/install-sh2ju.sh
ADD scripts/provision.sh
ADD tests/*
RUN ./provision.sh

CMD ["/etc/init.d/nginx"]
