FROM phzfi/ubuntu32:bionic

ADD scripts/provision.sh
RUN ./provision.sh

CMD ["/etc/init.d/nginx"]
