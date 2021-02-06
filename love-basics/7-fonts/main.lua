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

    -- new fonts
    font_big = love.graphics.newFont("font.ttf", 40)
    font_small = love.graphics.newFont("font.ttf", 24)
end

-- Called at every iteration of the game loop
function love.draw()
    love.graphics.setFont(font_big)
    love.graphics.printf("Hello, Pong", 0, WINDOW_HEIGHT/2 - 50, WINDOW_WIDTH, "center")
    love.graphics.setFont(font_small)
    love.graphics.printf("our very first game in LOVE", 0, WINDOW_HEIGHT/2, WINDOW_WIDTH, "center")
    
end