Paddle = class(Body) --bat

function Paddle:init(p)
    p.size = vec2(40 * pixel, 200 * pixel)
    p.friction = 0.8
    p.restitution = 0.4
    Body.init(self, p)
    self.normal = p.normal
    self.score = 0
    paddles[#paddles+1] = self
end

function Paddle:update()
    Body.update(self)
    self.pos = self.remotePos or self.pos
   -- self.vel = self.remoteVel or self.vel
end
