#FROM phzfi/ubuntu32:bionic
FROM phzfi/ubuntu32:bionic-20211118
RUN apt-get update && \
apt-get -y install \
nginx-extras \
nano \
less \
git \
wget \
curl

CMD ["/etc/init.d/nginx"]
