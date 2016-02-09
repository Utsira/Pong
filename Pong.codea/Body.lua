Body = class() --master class for game objects, handles drawing, "physics", restarts, LAN transmission if applicable

function Body:init(p)
    self.pos, self.startPos = p.pos, p.pos
    self.vel = p.vel or vec2(0,0)
    self.angle = p.angle or 0
    self.angularVel = p.angularVel or 0
    self.size = p.size
    self.radius = self.size / 2
    self.restitution = p.restitution or 1
    self.friction = p.friction or 1
    
    self.transmitter = p.transmitter
  --  self.transmitDelay = 0
    bodies[#bodies+1] = self
end

function Body:reset()
    self.pos = self.startPos
    self.vel = vec2(0,0)
end

function Body:update()
    self.pos = self.pos + self.vel * DeltaTime --delta time to account for differences in speed between devices
    self.angle = self.angle + self.angularVel * DeltaTime
    --resolve wall collisions (top and bottom)
    if (self.pos.y < self.radius.y) or (self.pos.y > HEIGHT - self.radius.y) then
        self.vel.y = -self.vel.y
        self.pos.y = self.pos.y + self.vel.y * DeltaTime
        self.vel.y = self.vel.y * self.restitution 
    end
    self.vel = self.vel * self.friction --apply friction
    self.angularVel = self.angularVel * 0.95
    --[[
    if self.transmitter then --and ElapsedTime > self.transmitDelay
       -- self.transmitDelay = ElapsedTime + 0.05
        multiplayer:cacheData(serializePosVel(1,self.transmitter, self.pos, self.vel))
    end
      ]]
end

function Body:transmit()
    multiplayer:cacheData(serializePosVel(self.transmitter, self.pos, self.vel))
end

function Body:draw()
    pushMatrix()
    translate(self.pos.x, self.pos.y)
    rotate(self.angle)
    rect(0,0, self.size.x, self.size.y)
    popMatrix()
    if self.remotePos then
        pushStyle()
        noFill()
        strokeWidth(5)
        stroke(0, 174, 255, 255)
        rect(self.remotePos.x, self.remotePos.y, self.size.x, self.size.y)
        popStyle()
    end
end
