-- MQTT FUNCTIONS
require('config')

-- Ping the broker
function ping()  
    m:publish("/ping", '{"id"="'..CLIENT_ID..'", "ip"="'..wifi.sta.getip()..'"}', 0, 0, function(conn)
        --print("Successfully publish a ping to the broker")
    end)
end

-- Subscribe to the broker
function subscribe()  
    topic = "/sensors/#"
    m:subscribe(topic, 0, function(conn)
        print("Successfully subscribed to the topic: "..topic)
    end)
end
