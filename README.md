# Display 3 sensor values from a MQTT topic

This LUA script is for ESP8266 hardware.

## Description

MQTT client displaying 3 values on a i2c 128x64 OLED display using U8G library

##Files

* ``config.lua``: Configuration variables
* ``init.lua``: Connect to a wifi AP and then execute main.lua file
* ``mqtt_function.lua``: Generic functions for MQTT broker
* ``main.lua``: Main file
 
## Principle

1. Start a MQTT client and then try to connect to a MQTT broker
2. Subscribe to a topic and update values on the display

## Scheme

![scheme](https://github.com/Wifsimster/i2c-display-mqtt/blob/master/scheme.png)

![scheme](https://github.com/Wifsimster/i2c-display-mqtt/blob/master/IMG_20160408_205334.jpg)
