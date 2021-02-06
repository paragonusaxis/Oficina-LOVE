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

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- table with RGB values
    background_color = {0, 0, 0}
end

-- Callback function, it's called everytime a key is pressed
function love.keypressed(key)
    -- if space is pressed
    if key == "space" then
        -- iterate over our table and assign random numbers to each entry
        for k in ipairs(background_color) do
            -- 255 possible numbers from 0 to 1
            background_color[k] = math.random(255)/255
        end
    end
end

-- Called at every iteration of the game loop
function love.draw()
    -- sets background color using our color table
    love.graphics.setBackgroundColor(background_color)
    -- writes on the screen
    love.graphics.printf("PRESS SPACE", 0, WINDOW_HEIGHT/2, WINDOW_WIDTH, "center")
end
