require('config')
require('mqtt_function')
local ntp = require('ntp')

m = nil

-- Init i2c display
i2c.setup(0, SDA_PIN, SCL_PIN, i2c.SLOW)
disp = u8g.ssd1306_128x64_i2c(SLA)

local function draw(temp_1, temp_2, temp_3)
   disp:setFont(u8g.font_6x10)
   disp:drawStr(30, 10, "Températures")
   if temp_1~=nil then disp:drawStr(20, 25, "Bureau: "..temp_1.." °C") end
   if temp_2~=nil then disp:drawStr(20, 38, "Chambre: "..temp_2.." °C") end
   if temp_3~=nil then disp:drawStr(20, 51, "Cuisine: "..temp_3.." °C") end  
end

local function display(temp_1, temp_2, temp_3)
  disp:firstPage()
  repeat
       draw(temp_1, temp_2, temp_3)
  until disp:nextPage() == false
end

-- Init client with keepalive timer 120sec
m = mqtt.Client(CLIENT_ID, 120, "", "")

-- Sync to NTP server
ntp.sync()

m:on("message", function(conn,topic,payload)
    print(topic)
    print(payload)
    if payload ~=nil then
        data = cjson.decode(payload)
        if topic == "/sensors/office/dht11/data" then
            if data.temperature~=nil then temp_1 = data.temperature end
        end
        if topic == "/sensors/bedroom/bs18b20/data" then
            if data.temp~=nil then temp_2 = data.temp end
        end        
        if topic == "/sensors/livingroom/bmp180/data" then
            if data.temp~=nil then temp_3 = data.temp end
        end
        display(temp_1, temp_2, temp_3)
    end
end)

print("Connecting to MQTT: "..BROKER_IP..":"..BROKER_PORT.."...")
m:connect(BROKER_IP, BROKER_PORT, 0, 1, function(conn)
    print("Connected to MQTT: "..BROKER_IP..":"..BROKER_PORT.." as "..CLIENT_ID)
    subscribe()
    -- Pings every 10 secs
    tmr.alarm(2, 10000, 1, ping)
end)
