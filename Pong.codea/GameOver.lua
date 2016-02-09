GameOver = class(Scene)

function GameOver:init(winner)
    Scene.init(self)
    players[winner].score = players[winner].score + 1
    self.note = "Player "..winner.." wins!"
    self.timer = ElapsedTime + 0.5
    ballSpeed = ballSpeed + 40 * pixel
    
    local x = WIDTH/2
    local y = HEIGHT/3
    buttons = {
    
    Button{x=x, y = y*2, title = "Play again", 
        callback = function()
            self.note = "Restarting"
            game:reset()
            scene = game
        end
        },
    
    Button{x=x, y=y, title = "Quit",
        callback = function()
            splash = Splash{}
        end}
    }
    
end
