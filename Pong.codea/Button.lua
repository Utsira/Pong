Button = class() --v simple 1-press triggers callback buttons

function Button:init(p)
    self.x, self.y = p.x, p.y
    self.title = p.title
    self.w, self.h = textSize(self.title)
    local padding = 40 * pixel
    self.w = self.w + padding
    self.h = self.h + padding
    local pos = vec2(p.x, p.y)
    local radius = vec2(self.w, self.h)/2
    self.aa, self.bb = pos - radius, pos + radius
    self.callback = p.callback
end

function Button:draw()
    if self.highlight then
        fill(255, 180)
        rect(self.x, self.y, self.w, self.h)
        fill(40, 180)
    else
        fill(40, 180)
        rect(self.x, self.y, self.w, self.h)
        fill(255, 180)
    end
    text(self.title, self.x, self.y)
end

function Button:touched(t)
    if t.state == BEGAN and self:inbox(t.x, t.y) then
        self.touch = t.id
        self.highlight = true
    elseif self.touch == t.id and t.state == ENDED then
        self.highlight = false
        self.touch = nil
        self.callback()
    end
end

function Button:inbox(x,y)
    return x>self.aa.x and x<self.bb.x and y>self.aa.y and y<self.bb.y
end
