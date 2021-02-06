-- Kitty Pong!!!

------------------------------------------------

Class = require 'lib/class'
require 'src/constants'
require 'src/utils'
require 'src/Paddle'
require 'src/Ball'

-- Called just once at the start of the game
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = 1
    })

    love.window.setTitle('Kitty Pong!')

    math.randomseed(os.time())

    -- Fonts
    main_font = love.graphics.newFont("fonts/sans-font.ttf", 30)
    main_font_small = love.graphics.newFont("fonts/sans-font.ttf", 18)
    title_font = love.graphics.newFont("fonts/purrfect-font.ttf", 42)
    points_font = love.graphics.newFont("fonts/purrfect-font.ttf", 30)

    love.graphics.setFont(main_font)

    -- Background
    background = love.graphics.newImage("graphics/background1.png")

    -- Sprites
    sprites = {
        paw1 = love.graphics.newImage("graphics/patinha-esquerda.png"),
        paw2 = love.graphics.newImage("graphics/patinha-di.png"),
        ball = love.graphics.newImage("graphics/novelo.png"),
        p1 = love.graphics.newImage("graphics/p1.png"),
        p2 = love.graphics.newImage("graphics/p2.png")    
    }

    sounds =  {
        wall_hit = love.audio.newSource('sounds/waal-hit.wav', 'static'),
        player1_hit = love.audio.newSource('sounds/plaayer1-hit.wav', 'static'),
        player2_hit = love.audio.newSource('sounds/plaayer2-hit.wav', 'static'),
        theme = love.audio.newSource('sounds/butterfly.mp3', 'static'),
        score = love.audio.newSource('sounds/scoore.wav', 'static')
    }

    --Plays main soundtrack in a loop
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
player1 = Paddle(20, WINDOW_HEIGHT/2 - sprites.paw1:getHeight()/2, sprites.paw1)
player2 = Paddle(WINDOW_WIDTH - 20 - sprites.paw2:getWidth(), 
    WINDOW_HEIGHT/2 - sprites.paw2:getHeight()/2, 
    sprites.paw2
)

-- Initializes our ball
ball = Ball()

game_state = 'start'

end

-- Called at every frame of our game, handles dt as argument
function love.update(dt)
    -- Player 1 movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- Player 2 movement
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
         player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- Updates the paddles
    player1:update(dt)
    player2:update(dt)

    -- If we are in the serve state, reset the ball position based on the serving player
    if game_state == 'serve' then
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
        if ball:collides(player1) then
            -- plays sounds effect
            sounds.player1_hit:play()

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
            sounds.player2_hit:play()
            
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
    if key == 'escape' then
        -- Terminates the game
        love.event.quit()
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
    love.graphics.setColor(1, 1, 1, 0.5)

    -- Draws the background
    love.graphics.draw(background)

    -- Sets opacity back to 100%
    love.graphics.setColor(1, 1, 1, 1)

    -- Draws different things depending on the state of the game
    if game_state == 'start' then
        -- Draws some cryptic text in runic font
        love.graphics.setFont(title_font)
        love.graphics.printf('Kitty Pong!!!', 0, WINDOW_HEIGHT/2 - 40, WINDOW_WIDTH, 'center')
        
        love.graphics.setFont(main_font)
        love.graphics.printf('Press enter to start', 0, WINDOW_HEIGHT/2 + 40, WINDOW_WIDTH, 'center')
    else
        -- Draws the soul gems
        love.graphics.draw(sprites.p1, 20, 27)
        love.graphics.draw(sprites.p2, WINDOW_WIDTH - 44, 27)

        -- Draws the points in gothic font
        love.graphics.setFont(points_font)
        love.graphics.printf(player1_score, 64, 25, WINDOW_WIDTH/2 - 100, 'left')
        love.graphics.printf(player2_score, WINDOW_WIDTH/2 + 100, 25, WINDOW_WIDTH/2 - 164, 'right')
        
        -- Returns to deafult font
        love.graphics.setFont(main_font)
        
        if game_state == 'serve' then
            love.graphics.printf('Player ' .. serving_player .. ' is serving', 0, 100, WINDOW_WIDTH, 'center')
            love.graphics.setFont(main_font_small)
            love.graphics.printf('press enter to serve', 0, 140, WINDOW_WIDTH, 'center')
        elseif game_state == 'done' then
            love.graphics.setFont(title_font)
            love.graphics.printf('player ' .. winning_player .. ' has won', 0, WINDOW_HEIGHT/2 - 40, WINDOW_WIDTH, 'center')
            love.graphics.setFont(main_font)
            love.graphics.printf('press enter to restart', 0, WINDOW_HEIGHT/2 + 40, WINDOW_WIDTH, 'center')
        end

        -- Renders ball
        ball:render()

        -- Renders players's paddles
        player1:render()   
        player2:render()
    end
end
