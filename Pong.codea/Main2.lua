
--[[
function setup()
    local connectionMade = function()
        output.clear()
        parameter.clear()
        print("Connected!")
        
        gameSetup()
    end
    
    multihandler = Multiplayer(receiveData, connectionMade)
    
    parameter.action("Host Game", function()
        multihandler:hostGame()
    end)
    
    parameter.action("Find Game", function()
        multihandler:findGame()
    end)
    
    parameter.action("Join Game", function()
        if other_ip then
            multihandler:joinGame(other_ip, other_port)
        else
            parameter.text("other_ip", "")
            parameter.text("other_port", "")
            
            print("Fill in the host's ip and port, then click join game again")
        end
    end)
end

function gameSetup()
    canvas = image(WIDTH, HEIGHT)
    parameter.color("pen_col", color(0, 255, 0))
    parameter.integer("pen_size", 2, 100, 10)
    parameter.action("clear", function()
        clear()
        multihandler:sendData("clear")
    end)
    pen_touch = nil
    last_point = vec2(0, 0)
end

function clear()
    canvas = image(WIDTH, HEIGHT)
end

function receiveData(d)
    if d == "clear" then
        clear()
    else
        local tb = loadstring("return " .. d)()
        drawPoint(tb.point, tb.last_point, tb.drawing_line, tb.pen_size, tb.pen_col)
    end
end

function drawPoint(point, lastPoint, drawingLine, penSize, penCol)
    pushStyle()
    setContext(canvas)    -- Start drawing to screen image
    
    fill(penCol) stroke(penCol)    -- Set draw color to color var
    
    strokeWidth(penSize)
    if drawingLine then
        line(point.x, point.y, lastPoint.x, lastPoint.y)    -- draw a line between the two points
    else
        ellipse(point.x, point.y, penSize)    -- Place a dot there
    end

    setContext()
    popStyle()
end

function draw()
    background(255, 255, 255, 255)

    multihandler:update()
    
    if multihandler.connected then
        sprite(canvas, WIDTH/2, HEIGHT/2, WIDTH, HEIGHT)    -- Draw the image onto the screen
    else
        fill(0)
        text("Waiting for connection...", WIDTH / 2, HEIGHT / 2)
    end
end

function vec2ToStr(vec)
    return "vec2" .. tostring(vec)
end

function colToStr(col)
    return "color(" .. col.r .. ", " ..  col.g .. ", " .. col.b.. ", " .. col.a .. ")"
end

function touched(t)
    if multihandler.connected then
        local p, lp, d, ps, pc = vec2(t.x, t.y), last_point, drawing_line, pen_size, pen_col
        if t.state == BEGAN then
            pen_touch = t.id
        end
        if t.id == pen_touch then
            drawPoint(vec2(t.x, t.y), last_point, drawing_line, pen_size, pen_col)
            drawing_line = true
            last_point = vec2(t.x, t.y)
        end
        if t.state == ENDED then
            drawing_line = false
            pen_touch = nil
        end
        
        multihandler:sendData("{ point = " .. vec2ToStr(p) .. ", last_point = " .. vec2ToStr(lp) .. ", drawing_line = " .. tostring(d) .. ", pen_size = " .. ps .. ", pen_col = " .. colToStr(pc) .. " }")
    end
end
  ]]

