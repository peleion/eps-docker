FROM docker.io/python:3.8-slim-buster

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y git; \
    rm -rf /var/lib/apt/lists/*; \
    cd /tmp; \ 
    git clone -b eps-v0.2.0 https://github.com/chris-belcher/electrum-personal-server.git; \
    cd electrum-personal-server; \
    pip3 install . ; \
    cp config.ini_sample /srv; \
    rm -rf /tmp/electrum-personal-server; \
    apt-get purge -y git; \
    apt-get -y autoremove

COPY --chown=root:root root/ /

VOLUME /srv

EXPOSE 50002

CMD /run-container
