GameClient = class(GameHost) --2 player game hosted by client

function GameClient:init(p)
    Game.init(self, p)
    self.player = 2
    players = {
    Paddle{pos = vec2(WIDTH * 0.05, HEIGHT * 0.5), normal = vec2(-1,0)},
    Droid{pos = vec2(WIDTH * 0.95, HEIGHT * 0.5), normal = vec2(1,0), transmitter = 2},
    }
    ball = Body{pos = vec2(WIDTH,HEIGHT)/2, size = vec2(40 * pixel, 40 * pixel)} --vel = vec2(plusMinus(), math.random()-0.5) * ballSpeed, 
end

function GameClient:fireBall()
    
end
