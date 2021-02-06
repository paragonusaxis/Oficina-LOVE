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

    -- Creates our image object in memory
    character = love.graphics.newImage("assets/character.png")
end

-- Called at every iteration of the game loop
function love.draw()
    -- Changes background color to white
    love.graphics.setBackgroundColor(1, 1, 1, 1)
    -- Draws our image
    love.graphics.draw(character, WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 
        0, 2, 2, 
        character:getWidth()/2, character:getHeight()/2)
end
