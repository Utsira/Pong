Body = class() --master class for game objects, handles drawing, "physics", restarts, LAN transmission if applicable

function Body:init(p)
    self.pos, self.startPos = p.pos, p.pos
    self.vel = p.vel or vec2(0,0)
    self.size = p.size
    self.radius = self.size / 2
    self.restitution = p.restitution or 1
    self.friction = p.friction or 1
    self.transmitter = p.transmitter
    bodies[#bodies+1] = self
end

function Body:reset()
    self.pos = self.startPos
    self.vel = vec2(0,0)
end

function Body:update()
    self.pos = self.pos + self.vel * DeltaTime --delta time to account for differences in speed between devices
    
    --resolve wall collisions (top and bottom)
    if (self.pos.y < self.radius.y) or (self.pos.y > HEIGHT - self.radius.y) then
        self.vel.y = -self.vel.y
        self.pos.y = self.pos.y + self.vel.y * DeltaTime
        self.vel.y = self.vel.y * self.restitution 
    end
    self.vel = self.vel * self.friction --apply friction
    
    if self.transmitter then
        multiplayer:cacheData(serializePosVel(1,self.transmitter, self.pos, self.vel))
    end
end

function Body:draw()
    rect(self.pos.x, self.pos.y, self.size.x, self.size.y)
end
