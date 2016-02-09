displayMode(OVERLAY)
displayMode(FULLSCREEN)

function setup()
    supportedOrientations(LANDSCAPE_ANY)
    pixel = math.max(WIDTH, HEIGHT)/1024
    fill(250)
    noStroke()
    rectMode(CENTER)
    font("Inconsolata")
    fontSize(40 * pixel)
    ballSpeed = 360 * pixel
   -- game = Game()
    splash = Splash()
    parameter.watch("players[2].pos")
end

function draw()
    scene:update()
    background(0)
    scene:draw()
end

function touched(t)
    scene:touched(t)
end

function null() end 

function clamp(v,low,high)
    return math.min(high, math.max(low, v))
end

function plusMinus() --returns either -1 or 1
    return (math.random(2)-1.5)*2
end
