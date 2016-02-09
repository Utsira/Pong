Splash = class(Scene)

function Splash:init()
    game = GameDemo{}
    Scene.init(self)

    local x = WIDTH/2
    local y = HEIGHT/4
    buttons = {
        Button{x=x, y=y*3, title = "Single Player", 
        callback = function() 
            game = GameSingle{}
        end},
    
        Button{x=x, y=y*2, title = "Start local multiplayer game", 
        callback = function() 
            self.note = "Waiting for other device" 
            multiplayer = Multiplayer() 
            multiplayer:hostGame(Splash.hostGame) 
        end},
    
        Button{x=x, y=y, title = "Join local multiplayer game", 
            callback = function() 
                self.note = "Searching for local game" 
                multiplayer = Multiplayer() 
                multiplayer:findGame(Splash.findGame) 
        end},
    }
    self.x1 = -WIDTH * 0.5
    self.x2 = WIDTH * 1.5
    tween(10, self, {x1 = WIDTH * 0.56, x2 = WIDTH * 0.42}, tween.easing.elasticOut) --WIDTH * 0.55, x2 = WIDTH * 0.45
end

function Splash:update()
    game:update()
end

function Splash.hostGame()
    game = GameHost{}
    multiplayer:ping(1)
end

function Splash.findGame()
    game = GameClient{}
  --  multiplayer:ping(2)
end

function Splash:draw()
    Scene.draw(self)
    pushStyle()
    blendMode(ADDITIVE)
    fill(80, 180)
    fontSize(1000 * pixel) --500
    text("Po", self.x2,HEIGHT* 0.44) --our funky logo 0.62
    text("ng", self.x1,HEIGHT * 0.82) --0.38
    blendMode(NORMAL)
    popStyle()
    
end


