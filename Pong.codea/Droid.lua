Droid = class(Paddle) --controlled by the iPad

function Droid:init(p)
    Paddle.init(self, p) 
    self.target = 0
    self.reactions = ElapsedTime + 0.1
    self.maxSpeed = 200 * pixel
end

function Droid:update()
    if ElapsedTime > self.reactions then
        self.target = ball.pos.y - self.pos.y
        self.reactions = ElapsedTime + math.random() --take eye off ball for a bit
    end
    self.vel.y = clamp(self.target * (0.1/DeltaTime), -self.maxSpeed, self.maxSpeed) 
    Body.update(self)
end
