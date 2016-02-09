Scene = class() --a master class for splash screens with buttons and notifications

function Scene:init()
    scene = self
    buttons = {}
    self.note = ""
end

function Scene:update()
    if multiplayer then multiplayer:update() end
end

function Scene:draw()
    if game then game:draw() end --draw the underlying scene, if there is one
    for i,v in ipairs(buttons) do
        v:draw()
    end
    if ElapsedTime % 0.5 > 0.25 then
        text(self.note, WIDTH * 0.5, HEIGHT * 0.85)
    end
end

function Scene:touched(t)
    for i,v in ipairs(buttons) do
        v:touched(t)
    end
end
