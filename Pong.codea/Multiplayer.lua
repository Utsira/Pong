local socket = require("socket")

Multiplayer = class()

function Multiplayer:init() --data callback, connection callback
    self.my_ip, self.my_port = self:getLocalIP(), 5400
    self.peer_ip, self.peer_port = nil, self.my_port
    self.latencies = {}
    self.client = socket.udp()
    self.client:settimeout(0)
    
    self.connected = false
    self.is_host = false
    self.searching = false
    self.clearCache = null
    self.messages = {"{"}
end

-- Returns this iPad's local ip
function Multiplayer:getLocalIP()
    local randomIP = "192.167.188.122"
    local randomPort = "3102" 
    local randomSocket = socket.udp() 
    randomSocket:setpeername(randomIP,randomPort) 

    local localIP, somePort = randomSocket:getsockname()

    randomSocket:close()
    randomSocket = nil

    return localIP
end

-- Set the connected status and call the connection callback if needed
function Multiplayer:setConnectedVal(bool)
    self.connected = bool
    
    if self.connected then
        self.connectedCallback()
    end
end

function Multiplayer:setHostVal(bool)
    self.is_host = bool
end

-- Prepare to be the host
function Multiplayer:hostGame(ccb)
    print("Connect to " .. self.my_ip .. ":" .. self.my_port)
    self.connectedCallback = ccb
    self.client:setsockname(self.my_ip, self.my_port)
    self:setConnectedVal(false)
    self.is_host = true
    self.searching = false
end

-- Find a host
function Multiplayer:findGame(ccb)
    print("Searching for games...")
    self.connectedCallback = ccb
    self.searching = true
    
    local ip_start, ip_end = self.my_ip:match("(%d+.%d+.%d+.)(%d+)")
    for i = 1, 255 do
        if i ~= tonumber(ip_end) then
            tween.delay(0.01 * i, function()
                self.client:setsockname(ip_start .. i, self.my_port)
                self.client:sendto("connection_confirmation", ip_start .. i, self.my_port)
            end)
        end
    end
    
    tween.delay(0.01 * 256, function()
        if not self.connected then
            alert("Make sure the host has started and is on the same network.", "No matches found.")
        end
    end)
end

-- Prepare to join a host
function Multiplayer:joinGame(ip, port)
    self.peer_ip, self.peer_port = ip, port
    
    self.client:setsockname(ip, port)
    
    self.is_host = false
    self.searching = false
    
    self:sendData("connection_confirmation")
end

-- Send data to the other client
function Multiplayer:sendData(msg_to_send)
    if self.peer_ip then
        self.client:sendto(msg_to_send, self.peer_ip, self.peer_port)
    end
end

-- Check for data received from the other client
function Multiplayer:checkForReceivedData()
    local data, msg_or_ip, port_or_nil = self.client:receivefrom()
    if data and data ~= "" then
            -- Store the ip of this new client so you can send data back
        self.peer_ip, self.peer_port = msg_or_ip, port_or_nil
            
        if not self.connected and data == "connection_confirmation" then
            self:sendData("connection_confirmation")
            self:setConnectedVal(true)
        end
            
        -- Call callback with received data
        if data ~= "connection_confirmation" then
            self:dataReceived(data)
        end
    end
end

function Multiplayer:update()
    self:checkForReceivedData()
    self:clearCache()
end

function Multiplayer:setPos(d)
    local bod = bodies[d.id]
    local pos = d.pos * pixel
    local vel = d.vel * pixel  
    bod.remotePos = pos + vel * self.latency
    bod.vel = vel
end

local syncEvents = {
    function() Game.reset(game) scene = game end, 
    function() end --dummy, for measuring latency
} 

function Multiplayer:ping(callback)
    self.pinger = ElapsedTime
  --  self.synced = false
    self:cacheData{serialize{fn = remote_pingBack, cb = callback}}
    self.clearCache = self.sendCache --send the cache
end

function Multiplayer:pingBack(d)

   -- if not self.synced then --if not the host
      --  print("syncing")
       -- self:sendData(str) --echo the sync message back
        
        self:cacheData{serialize{fn=remote_syncAndProceed,cb=d.cb}, ",{fn=2},"} --send remote_syncAndProceed with the callback, and remote_pingBack without the callback, so that the callback is only executed once per device
      --  self.synced = true
    self.pinger = ElapsedTime
    if d.cb then
        syncEvents[d.cb]() --callback
    end
   -- end
    for i,v in ipairs(bodies) do --get the latest positions
        if v.transmitter then v:transmit() end
    end
    self.clearCache = self.sendCache --send the cache
end

function Multiplayer:syncAndProceed(d)
     --if self.syncHost then --message has been received back by host
        table.insert(self.latencies, (ElapsedTime - self.pinger) * 0.5)
        if #self.latencies>20 then table.remove(self.latencies, 1) end
        self.latency = table.average(self.latencies)
        print("latency", self.latency)
      --  self.pinger = false
       -- self.synced = true
    if d.cb then
        syncEvents[d.cb]() --callback
    end
    

   -- end   
end

local functions = {Multiplayer.setPos, Multiplayer.pingBack, Multiplayer.syncAndProceed}
remote_setPos = 1
remote_pingBack = 2
remote_syncAndProceed = 3

function Multiplayer:dataReceived(str)
    print("received", str)
    local data = load("return "..str)()
    for _,item in ipairs(data) do
        functions[item.fn](self, item)
    end
end

function Multiplayer:cacheData(tab)
    table.move(tab,1,#tab,#self.messages+1, self.messages)
 --   print("caching", table.concat(self.messages))
end

function Multiplayer:sendCache()
    --if #self.messages>1 then --messages to send
        table.insert(self.messages,"}") --close the list
        local msg = table.concat(self.messages)
        print("sending", msg)
        self:sendData(msg) --create the string
        self.messages = {"{"} --clear the cache
  --  end
    self.clearCache = null
end

function serialize(tab)
    local out = {"{"}
    for k,v in pairs(tab) do
        out[#out+1] = table.concat{k,"=",v,","}
    end
    out[#out+1] = "}"
    return table.concat(out)
end

function serializePosVel(id, pos, vel)
    return {"{fn=1,id=", id, ",pos=", vec2String(pos/pixel), ",vel=", vec2String(vel/pixel), "},"}
end

function vec2String(v)
    return string.format("vec2(%.1f,%.1f)", v.x, v.y) --only one decimal place for vec2s, to save bandwidth
end
