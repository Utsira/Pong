Player = class(Paddle) --controlled by player on this device

function Player:init(p)
    Paddle.init(self,p)
    self.touches = {}
end

function Player:touched(t)
    if t.state == ENDED then
        local vel = table.average(self.touches) --average the last 10 touches
        self.touches = {}
        self.vel.y = vel
    else
        local vel = t.deltaY * (1/DeltaTime)
        table.insert(self.touches, 1, vel) --record up to 10 touches
        if #self.touches>10 then
            table.remove(self.touches)
        end
        self.vel.y = vel
    end
end

function table.average(tab)
    return load("return "..table.concat(tab, "+"))()/#tab
end
