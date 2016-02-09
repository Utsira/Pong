GameHost = class(Game) --2 player game hosted by this device

function GameHost:init(p)
    parameter.watch("multiplayer.latency")
    Game.init(self, p)
    self.player = 1
    players = {Player{pos = vec2(WIDTH * 0.05, HEIGHT * 0.5), normal = vec2(1,0), transmitter = 1},
    Paddle{pos = vec2(WIDTH * 0.95, HEIGHT * 0.5), normal = vec2(-1,0)}}
    ball = Ball{pos = vec2(WIDTH,HEIGHT)/2, transmitter = 3} --, vel = vec2(plusMinus(), math.random()-0.5) * ballSpeed, 
  --  self:fireBall()
    tween.delay(1, function() self:fireBall() end)
end

function GameHost:reset() --nb GameClient inherits this, so eith host or client can restart game with tap.
    multiplayer:ping(1)
end

