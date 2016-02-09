Ball = class(Body)

function Ball:init(p)
    p.size = vec2(40 * pixel, 40 * pixel)
    Body.init(self,p)
    self.velToDegrees = (180/math.pi)/self.radius.x
end

function Ball:update()
    Body.update(self)
    
    --game over conditions
    if self.pos.x < -self.radius.x then
        splash = game.gameOver(2)
    elseif self.pos.x > WIDTH + self.radius.x then
        splash = game.gameOver(1)
    end
    
    --paddle collisions
    local a, b = self.pos - self.radius, self.pos + self.radius
    for i,v in ipairs(paddles) do
        local aa,bb = v.pos - v.radius, v.pos + v.radius
        if b.x > aa.x and a.x < bb.x and b.y > aa.y and a.y < bb.y then
            if self.vel:dot(v.normal) < 0 then
                self.vel.x = -self.vel.x
                self.pos.x = self.pos.x + self.vel.x * DeltaTime
                self.angularVel = (self.vel.y - v.vel.y) * -self.velToDegrees
                self.vel.y = ((self.pos.y - v.pos.y) * 2) - v.vel.y --top-spin
                
                return
            end
        end
    end
end

