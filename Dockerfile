FROM redbubble/rb-debian:master

RUN apt-get update && apt-get install -y --no-install-suggests --no-install-recommends \
    wget \
    openjdk-8-jdk-headless

RUN wget https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt -O /usr/bin/sbt && \
    chmod +x /usr/bin/sbt

RUN sbt -sbt-create