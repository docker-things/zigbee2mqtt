#!/bin/bash

# Command used to launch docker
DOCKER_CMD="`which docker`"

# Where to store the backups
BACKUP_PATH=""

# Where to store the communication pipes
FIFO_PATH="/tmp/docker-things/fifo"

# The name of the docker image
PROJECT_NAME="zigbee2mqtt"

# BUILD ARGS
BUILD_ARGS=(
    --build-arg DOCKER_USERID=$(id -u)
    --build-arg DOCKER_GROUPID=$(id -g)
    --build-arg DOCKER_USERNAME=$(whoami)
    )

ZIGBEE2MQTT_DEVICE="/dev/ttyACM0"

# LAUNCH ARGS
RUN_ARGS=(
    -h "$PROJECT_NAME"

    --memory="256m"
    --cpu-shares=1024

    # persistent changes will be stored in:
    -v $(pwd)/data:/app/data

    # zigbee2mqtt device
    --device=$ZIGBEE2MQTT_DEVICE

    --rm
    -d
    )
