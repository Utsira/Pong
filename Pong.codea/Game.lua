Game = class()

function Game:init(p)
    bodies = {}
    paddles = {}
    self.gameOver = p.gameOver or GameOver
    scene = self
end

function Game:update()
    for i,v in ipairs(bodies) do
        v:update()
    end
    if multiplayer then multiplayer:update() end
end

function Game:draw()
    for i,v in ipairs(bodies) do
        v:draw()
    end
    text(players[1].score.." : "..players[2].score, WIDTH * 0.5, HEIGHT * 0.95)
end

function Game:touched(t)
    players[self.player]:touched(t)
end

function Game:reset()
    print("resetting")
    for i,v in ipairs(bodies) do
        v:reset()
    end    
    self:fireBall()
end

function Game:fireBall()
    ball.vel = vec2(plusMinus(), math.random()-0.5) * ballSpeed
end
