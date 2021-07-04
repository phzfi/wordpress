FROM phzfi/ubuntu32:bionic
RUN apt-get update && \
apt-get -y install \
nginx-extras \
nano \
less \
git \
wget \
curl

CMD ["/etc/init.d/nginx"]
