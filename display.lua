require('config')

SCL = 3 -- GPIO_0
SDA = 4 -- GPIO_2
SLA = 0x3c

-- Init i2c display
i2c.setup(0, SDA, SCL, i2c.SLOW)
disp = u8g.ssd1306_128x64_i2c(SLA)

-- the draw() routine
function draw(temp, pres, lux)
   disp:setFont(u8g.font_6x10)
   disp:drawStr(45, 10, "Bureau")
   --disp:drawLine(0, 12, 128, 12);
   if temp~=nil then disp:drawStr(30, 25, temp.." °C") end
   if pres~=nil then disp:drawStr(30, 38, pres.." hPa") end
   if lux~=nil then disp:drawStr(30, 51, lux.." lux") end  
end
 
function display(temp, pres, lux)
  disp:firstPage()
  repeat
       draw(temp, pres, lux)
  until disp:nextPage() == false
end

-- Init client with keepalive timer 120sec
m = mqtt.Client(CLIENT_ID, 120, "", "")

tmr.alarm(0, 1000, 1, function()
    print("Connecting to MQTT: "..BROKER_IP..":"..BROKER_PORT.."...")
    tmr.stop(0)
    m:connect(BROKER_IP, BROKER_PORT, 0, function(conn)
        print("Connected to MQTT: "..BROKER_IP..":"..BROKER_PORT.." as "..CLIENT_ID)
        -- Subscribe to a topic
        m:subscribe("/sensors/bureau/#", 0, function(conn)
            m:on("message", function(m,t,pl)
                if pl ~=nil then
                    data = cjson.decode(pl)
                    -- data: {"temp":"28.5","pres":"1014.2"}
                    -- data: {"lux_0":"0","lux_1":"139"}
                    if data.temp~=nil then temp = data.temp end
                    if data.pres~=nil then pres = data.pres end
                    if data.lux_1~=nil then lux = data.lux_1 end
                    display(temp, pres, lux)
                end
            end)
        end)
    end)
end)