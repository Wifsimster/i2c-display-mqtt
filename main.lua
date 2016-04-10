require('config')
require('mqtt_function')

SCL = 3 -- GPIO_0
SDA = 4 -- GPIO_2
SLA = 0x3c
TOPIC = "/sensors/bureau/#"
m = nil

-- Init i2c display
i2c.setup(0, SDA, SCL, i2c.SLOW)
disp = u8g.ssd1306_128x64_i2c(SLA)

local function draw(temp, pres, lux)
   disp:setFont(u8g.font_6x10)
   disp:drawStr(45, 10, "Bureau")
   if temp~=nil then disp:drawStr(30, 25, temp.." °C") end
   if pres~=nil then disp:drawStr(30, 38, pres.." hPa") end
   if lux~=nil then disp:drawStr(30, 51, lux.." lux") end  
end

local function display(temp, pres, lux)
  disp:firstPage()
  repeat
       draw(temp, pres, lux)
  until disp:nextPage() == false
end

-- Init client with keepalive timer 120sec
m = mqtt.Client(CLIENT_ID, 120, "", "")

m:on("message", function(conn,topic,payload)
    print(payload)
    if payload ~=nil then
        data = cjson.decode(payload)
        if data.temp~=nil then temp = data.temp end
        if data.pres~=nil then pres = data.pres end
        if data.lux_1~=nil then lux = data.lux_1 end
        display(temp, pres, lux)
    end
end)
            
print("Connecting to MQTT: "..BROKER_IP..":"..BROKER_PORT.."...")

m:connect(BROKER_IP, BROKER_PORT, 0, function(conn)
    print("Connected to MQTT: "..BROKER_IP..":"..BROKER_PORT.." as "..CLIENT_ID)
    subscribe()
    -- Pings every 10 secs
    tmr.alarm(2, 10000, 1, ping)
end)
