-- Constants
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

-- Called just once at the start of the program
function love.load()
    -- Sets some configurations
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = 1
    })
end

-- Called at every iteration of the game loop
function love.draw()
    -- Draws a filled rectangle at x = 100, y = 100, width = 100 and height = 100
    love.graphics.rectangle('fill', 100, 100, 100, 100)
    
    -- Changes color to a pure red (R, G, B, Alpha)
    love.graphics.setColor(1, 0, 0, 1)
    -- Draws a lined circle at the middle of the screen, radius = 50
    love.graphics.circle('line', WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 50)
    -- Changes color back to white
    love.graphics.setColor(1, 1, 1, 1)

    -- Draws a filed polygon (more precisely a rectangle) with the following points (x,y): 
    --      (200, 300)(350,400)(200,500)
    love.graphics.polygon('fill', 200, 300, 350, 400, 200, 500)
end
