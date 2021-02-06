-- Constants
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

-- Called just once at the start of the program
function love.load()
    -- No filtering of pixels, without this our sprites will look blurry.
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- Sets some configurations
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = 1
    })

    -- square variables
    square_width = 50
    square_height = 50
    square_x = WINDOW_WIDTH/2 - square_width/2
    square_y = 300
    square_speed = 400
end

-- Called at every iteration of the game loop
function love.update(dt)
    -- handles player movement in the X-axis
    if love.keyboard.isDown("left") then
        square_x = math.max(square_x - square_speed * dt, 0)
    elseif love.keyboard.isDown("right") then
        square_x = math.min(square_x + square_speed * dt, WINDOW_WIDTH - square_width)
    end
    
    if love.keyboard.isDown("up") then
        square_y = math.max(square_y - square_speed * dt, 0)
    elseif love.keyboard.isDown("down") then
        square_y = math.min(square_y + square_speed * dt, WINDOW_HEIGHT - square_height)
    end
end

-- Called at every iteration of the game loop
function love.draw()
    love.graphics.rectangle('fill', square_x, square_y, square_width, square_height)
end
