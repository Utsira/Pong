GameSingle = class(Game) --1 player game against AI

function GameSingle:init(p)
    Game.init(self, p)
    self.player = 1
    players = {Player{pos = vec2(WIDTH * 0.05, HEIGHT * 0.5), normal = vec2(1,0)},
    Droid{pos = vec2(WIDTH * 0.95, HEIGHT * 0.5), normal = vec2(-1,0)}}
    ball = Ball{pos = vec2(WIDTH,HEIGHT)/2} --, vel = vec2(plusMinus(), math.random()-0.5) * ballSpeed
  --  self:fireBall()
    tween.delay(1, function() self:fireBall() end)
end
