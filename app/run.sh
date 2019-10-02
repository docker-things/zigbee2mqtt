#!/bin/ash

DATA_DIR="/app/data"

# Data dir
if [ ! -d "$DATA_DIR" ]; then
    echo " > Creating data dir: $DATA_DIR"
    mkdir -p "$DATA_DIR"
fi

# Permissions
echo " > Make sure we've got permissions"
chown $DOCKER_USERNAME:$DOCKER_GROUPID -R "$DATA_DIR"
chmod 775 -R "$DATA_DIR"

# Go to the zigbee2mqtt dir
cd "$ZIGBEE2MQTT_PATH"

# Create link to data dir
rm -rf data
mkdir -p /app/data/zigbee2mqtt
ln -s /app/data/zigbee2mqtt data

# Make sure we've got a base cfg
if [ ! -f "$ZIGBEE2MQTT_PATH/data/configuration.yaml" ]; then
    echo "Creating zigbee2mqtt configuration file..."
    cp "$ZIGBEE2MQTT_PATH/configuration.yaml" "$ZIGBEE2MQTT_PATH/data/configuration.yaml"
fi

# Remove old logs
if [ -d "$ZIGBEE2MQTT_PATH/data/log" ]; then
    echo "Removing previous logs..."
    rm -rf $ZIGBEE2MQTT_PATH/data/log/*
fi

# Launch
while [ 1 = 1 ]; do
    npm start

    echo " > Service stopped, restarting in 5 seconds..."
    sleep 5s
done
