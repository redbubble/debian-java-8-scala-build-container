FROM redbubble/rb-debian:master

WORKDIR /app

RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends \
    wget \
    openjdk-8-jdk

RUN wget https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt -O /usr/bin/sbt && \
    chmod +x /usr/bin/sbt

#TODO: Download SBT so we don't have to do it on build. It's heaps slow.
