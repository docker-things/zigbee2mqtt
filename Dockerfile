FROM alpine:3.8
MAINTAINER Gabriel Ionescu <gabi.ionescu+docker@protonmail.com>

# CREATE USER
ARG DOCKER_USERID
ARG DOCKER_GROUPID
ARG DOCKER_USERNAME
ENV DOCKER_USERID $DOCKER_USERID
ENV DOCKER_GROUPID $DOCKER_GROUPID
ENV DOCKER_USERNAME $DOCKER_USERNAME
RUN echo -e "\n > CREATE DOCKER USER: $DOCKER_USERNAME\n" \
 && addgroup -g $DOCKER_GROUPID $DOCKER_USERNAME \
 && adduser -D -u $DOCKER_USERID -G $DOCKER_USERNAME $DOCKER_USERNAME

# INSTALL ZIGBEE2MQTT
ENV ZIGBEE2MQTT_PATH /app/zigbee2mqtt
RUN echo -e "\n > INSTALL ZIGBEE2MQTT IN $ZIGBEE2MQTT_PATH\n" \
 && apk add --no-cache --virtual=build-dependencies \
    make \
    gcc \
    g++ \
    python \
    linux-headers \
    udev \
    git \
 && apk add --no-cache \
    nodejs \
    npm \
 \
 && git clone https://github.com/koenkk/zigbee2mqtt $ZIGBEE2MQTT_PATH \
 && cd $ZIGBEE2MQTT_PATH \
 && cp data/configuration.yaml ./ \
 \
 && npm install --unsafe-perm \
 && npm i semver mqtt winston moment js-yaml object-assign-deep mkdir-recursive rimraf \
 \
 && echo -e "\n > CLEANUP\n" \
 && apk del --purge \
    build-dependencies \
 && rm -rf \
    $ZIGBEE2MQTT_PATH/.git \
    /tmp/* \
    /var/tmp/* \
    /root/*

# COPY APP FILES
COPY app/run.sh /app/run.sh

# WORKDIR
WORKDIR /app

# SWITCH USER
USER $DOCKER_USERNAME

# LAUNCH
CMD ["ash", "run.sh"]
