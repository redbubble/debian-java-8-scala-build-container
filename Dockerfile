FROM redbubble/rb-debian:master

ENV JAVA_VERSION 8u131
ENV JAVA_DEBIAN_VERSION 8u131-b11-2

RUN apt-get update && apt-get install -y --no-install-suggests --no-install-recommends \
    wget \
    openjdk-8-jdk-headless="$JAVA_DEBIAN_VERSION"

RUN wget https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt -O /usr/bin/sbt && \
    chmod +x /usr/bin/sbt

RUN sbt -sbt-create