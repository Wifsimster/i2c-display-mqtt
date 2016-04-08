# Display 3 sensor values from a MQTT topic

This LUA script is for ESP8266 hardware.

## Description

MQTT client displaying 3 values on a i2c 128x64 OLED display using U8G library

## Principle

1. Connect to a wifi AP
2. Start a MQTT client and try to connect to a MQTT broker
3. Subscribe to a topic and update values on the display

## Scheme

![scheme](https://github.com/Wifsimster/i2c-display-mqtt/blob/master/scheme.png)

![scheme](https://github.com/Wifsimster/i2c-display-mqtt/blob/master/IMG_20160408_205334.jpg)
