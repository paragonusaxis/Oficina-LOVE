--[[
    Puella Magi Pong Magica

    pong-11
    Final touches!
]]

-- class is a library that will allow us to modularize our game's code
-- in different components. This way we won't have to keep track
-- of many disparate variables and methods.
-- credit: https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

-- Requires constants.lua, where our global constants are defined
require 'src/constants'

-- Requires utils.lua so that we can use its useful functions
require 'src/utils'

-- Our Paddle class, that stores positions and dimensions for each paddle
require 'src/Paddle'

-- Our Ball class, same as our paddle class
require 'src/Ball'

-- Called just once at the start of the game
function love.load()
    -- No filtering of pixels, without this our sprites will look blurry.
    love.graphics.setDefaultFilter('nearest', 'nearest')
    -- Sets some configurations
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = 1
    })

    -- Sets the title of our application window
    love.window.setTitle('Puella Magi Pong Magica')

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- New fonts
    gothic_font = love.graphics.newFont('fonts/zinjaro.ttf', 54)
    rune_font = love.graphics.newFont('fonts/zinjaro.ttf', 64)
    serif_font = love.graphics.newFont('fonts/Flower.otf', 24)
    small_serif_font = love.graphics.newFont('fonts/Flower.otf', 18)

    love.graphics.setFont(serif_font)

    -- Background
    -- credit: https://gekidan-inu-curry.tumblr.com/page/4
    background = love.graphics.newImage('graphics/background.png')

    -- Sprites
    sprites = {
        madoka = love.graphics.newImage('graphics/pazinha1.png'),
        homura = love.graphics.newImage('graphics/pazinha2.png'),
        ball = love.graphics.newImage('graphics/bolinha.png'),
        gem_madoka = love.graphics.newImage('graphics/gem-p1.png'),
        gem_homura = love.graphics.newImage('graphics/gem-p2.png')
    }

    -- Sounds
    sounds =  {
        wall_hit = love.audio.newSource('sounds/borda.wav', 'static'),
        player_hit = love.audio.newSource('sounds/pa.wav', 'static'),
        theme = love.audio.newSource('sounds/theme.mp3', 'static'),
        score = love.audio.newSource('sounds/ponto.wav', 'static')
    }

    -- Plays main soundtrack in a loop
    sounds.theme:setLooping(true)
    sounds.theme:setVolume(0.5)
    sounds.theme:play()

    -- Variables that will store our points
    player1_score = 0
    player2_score = 0

    -- Initilizes the serving player, either 1 or 2. Who gets scored serves in the next turn.
    serving_player = 1

    -- Initializes the winning player, this is not a proper value right now
    winning_player = 0

    -- Initializes player1 and player2 as paddles
    player1 = Paddle(20, WINDOW_HEIGHT/2 - sprites.madoka:getHeight()/2, sprites.madoka)
    player2 = Paddle(WINDOW_WIDTH - 20 - sprites.homura:getWidth(), 
        WINDOW_HEIGHT/2 - sprites.homura:getHeight()/2, 
        sprites.homura
    )

    -- Initializes our ball
    ball = Ball()

    -- Game state variable used control our game's different 'moments'
    -- (used for beginning, menus, main game, high score list, etc.)
    -- we will use this to determine behavior during render and update
    game_state = 'start'
end

-- Called at every frame of our game, handles dt as argument
function love.update(dt)
    -- Player 1 movement
    if love.keyboard.isDown('w') then
        -- changes player1's dy to negative
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        -- Changes playery's dy to positive
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- Player 2 movement
    if love.keyboard.isDown('up') then
        -- changes player1's dy to negative
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
         -- Changes playery's dy to positive
         player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- Updates the paddles
    player1:update(dt)
    player2:update(dt)

    -- If we are in the serve state, reset the ball position based on the serving player
    if game_state == 'serve' then
        -- Let's randomize the ball's starting speed to make things more fun
        ball.speed = math.random(350, 400)

        if serving_player == 1 then
            ball.direction = math.random(-45, 45)
        else
            ball.direction = math.random(135, 225)
        end

        ball.dx, ball.dy = velocity(ball.speed, ball.direction)
    end

    -- If we are in the play state, check for collisions and update our ball
    if game_state == 'play' then
        -- detect ball collision with paddles, changing de direction of the ball if true and
        -- slightly increasing its speed
        if ball:collides(player1) then
            -- plays sounds effect
            sounds.player_hit:play()

            ball.speed = ball.speed * 1.05
            ball.x = player1.x + player1.width

            -- randomize the direction a little bit, for fun
            if ball.dy < 0 then
                ball.direction = math.random(290, 350)
            else
                ball.direction = math.random(20, 70)
            end

            ball.dx, ball.dy = velocity(ball.speed, ball.direction)
        end

        if ball:collides(player2) then
            -- plays sounds effect
            sounds.player_hit:play()
            
            ball.speed = ball.speed * 1.05
            ball.x = player2.x - ball.width

            -- randomize the direction a little bit, for fun
            if ball.dy < 0 then
                ball.direction = math.random(200, 250)
            else
                ball.direction = math.random(110, 160)
            end

            ball.dx, ball.dy = velocity(ball.speed, ball.direction)
        end


        -- detect upper and lower screen boundary collision and reverse dy if collided
        if ball.y <= 0 then
            -- plays sound effect
            sounds.wall_hit:play()

            ball.y = 0
            ball.dy = -ball.dy
        end

        if ball.y >= WINDOW_HEIGHT - ball.height then
            -- plays sound effect
            sounds.wall_hit:play()

            ball.y = WINDOW_HEIGHT - ball.height
            ball.dy = -ball.dy
        end
        
        -- detect left and right screen boundary collision, update scores and change state
        if ball.x + ball.width < 0 then
            -- player2 scored
            -- plays sound effect
            sounds.score:play()

            player2_score = player2_score + 1
            serving_player = 1

            -- if we've reached a score of 10, end the game
            if player2_score == 10 then
                winning_player = 2
                game_state = 'done'
            else
                ball:reset()
                game_state = 'serve'
            end            
        end

        if ball.x > WINDOW_WIDTH then
            -- player1 scored
            -- plays sound effect
            sounds.score:play()

            player1_score = player1_score + 1
            serving_player = 2
            
            -- if we've reached a score of 10, end the game
            if player1_score == 10 then
                winning_player = 1
                game_state = 'done'
            else
                ball:reset()
                game_state = 'serve'
            end
        end

        ball:update(dt)
    end
end

-- Called whenever you press a key in your keyboard, passes the key as argument
function love.keypressed(key)
    -- Keys can be accessed by their name as a string
    if key == 'escape' then
        -- Terminates the game
        love.event.quit()
    -- If we press enter during the start state of the game, we'll go into play mode
    -- during play mode, the ball will move in a random direction
    elseif key == 'enter' or key == 'return' then
        if game_state == 'start' then
            game_state = 'serve'
        elseif game_state == 'serve' then
            game_state = 'play'
        elseif game_state == 'done' then
            -- resets the game
            game_state = 'serve'
            
            ball:reset()

            player1_score = 0
            player2_score = 0
        end
    end
end

-- Called after love.update, responsible for drawing things in the game's screen
function love.draw()
    -- Sets opacity to 50%
    love.graphics.setColor(1, 1, 1, 1)

    -- Draws the background
    love.graphics.draw(background)

    -- Sets opacity back to 100%
    love.graphics.setColor(0.8, 0.9, 0.2, 1)

    -- Draws different things depending on the state of the game
    if game_state == 'start' then
        -- Draws some cryptic text in runic font
        love.graphics.setFont(rune_font)
        love.graphics.printf('GUARAPONG', 0, WINDOW_HEIGHT/2 - 40, WINDOW_WIDTH, 'center')
        
        love.graphics.setFont(serif_font)
        love.graphics.printf('Press enter to start', 0, WINDOW_HEIGHT/2 + 40, WINDOW_WIDTH, 'center')


    else

        love.graphics.setColor(1, 1, 1, 1)
        -- Draws the soul gems
        love.graphics.draw(sprites.gem_madoka, 20, 30)
        love.graphics.draw(sprites.gem_homura, WINDOW_WIDTH - 55, 30)

        -- Draws the points in gothic font
        love.graphics.setFont(gothic_font)
        love.graphics.printf(player1_score, 64, 20, WINDOW_WIDTH/2 - 100, 'left')
        love.graphics.printf(player2_score, WINDOW_WIDTH/2 + 100, 20, WINDOW_WIDTH/2 - 164, 'right')
        
        -- Returns to deafult font
        love.graphics.setFont(serif_font)
        
        if game_state == 'serve' then
            love.graphics.printf('Player ' .. serving_player .. ' is serving', 0, 100, WINDOW_WIDTH, 'center')
            love.graphics.setFont(small_serif_font)
            love.graphics.printf('press enter to serve', 0, 140, WINDOW_WIDTH, 'center')
        elseif game_state == 'done' then
            love.graphics.setFont(gothic_font)
            love.graphics.printf('player ' .. winning_player .. ' has won', 0, WINDOW_HEIGHT/2 - 40, WINDOW_WIDTH, 'center')
            love.graphics.setFont(serif_font)
            love.graphics.printf('press enter to restart', 0, WINDOW_HEIGHT/2 + 40, WINDOW_WIDTH, 'center')
        end

        -- Renders ball
        ball:render()

        -- Renders players's paddles
        player1:render()   
        player2:render()
    end
end
