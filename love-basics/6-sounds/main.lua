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

    -- creates our sources
    sound = love.audio.newSource("wall_hit.wav", "static")
    music = love.audio.newSource("music.wav", "stream")

    -- sets looping to true and start music
    music:setLooping(true)
    music:play()

    paused = false
end

-- Callback function, it's called everytime a key is pressed
function love.keypressed(key)
    -- if space is pressed
    if key == "space" then
        -- a sound is played to indicate we pressed the key
        sound:play()

        -- if paused, unpase
        if paused then
            paused = false
            music:play()
        -- if unpaused, pause
        else
            paused = true
            music:pause()
        end
    end
end

-- Called at every iteration of the game loop
function love.draw()
    -- writes on the screen
    if paused then
        love.graphics.printf("PRESS SPACE TO RESUME THE MUSIC", 0, WINDOW_HEIGHT/2, WINDOW_WIDTH, "center")
    else
        love.graphics.printf("PRESS SPACE TO PAUSE THE MUSIC", 0, WINDOW_HEIGHT/2, WINDOW_WIDTH, "center")
    end
end