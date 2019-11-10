FROM docker.io/python:3.8-slim-buster

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y  \
      curl; \
    rm -rf /var/lib/apt/lists/*

RUN cd /usr/local/src; \ 
    curl -sSL -o eps-v0.1.6.tar.gz https://github.com/chris-belcher/electrum-personal-server/archive/eps-v0.1.6.tar.gz; \
    tar xf eps-v0.1.6.tar.gz; \
    rm eps-v0.1.6.tar.gz ; \
    cd electrum-personal-server-eps-v0.1.6; \
    pip3 install . ; \
    cp /usr/local/etc/electrum-personal-server/config.cfg_sample /usr/local/etc/electrum-personal-server/config.cfg

VOLUME /usr/local/etc/electrum-personal-server

EXPOSE 50002

CMD electrum-personal-server /usr/local/etc/electrum-personal-server/config.cfg
