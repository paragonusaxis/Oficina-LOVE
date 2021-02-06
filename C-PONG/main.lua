Class = require 'lib/class'

require 'src/constants'

require 'src/Paddle'

require 'src/utils'

require 'src/Ball'



function love.load()
    -- Filtro das imagens
    love.graphics.setDefaultFilter('nearest', 'nearest')
   
    -- Configurações da tela
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = 1
    })
    -- mudando o título 
    love.window.setTitle("C-PONG")
    
    -- Fonte
    glitch_font = love.graphics.newFont("fonts/Glitch inside.otf", 30)
    glitch_font2 = love.graphics.newFont("fonts/Glitch inside.otf", 15)
   
    -- background
   background = love.graphics.newImage("graphics/fundo.png")

   titulo = love.graphics.newImage("graphics/titulo.png")
  
    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())


   -- Table Sprites
  sprites = {
    direita = love.graphics.newImage("graphics/direita.png"),
    esquerda = love.graphics.newImage("graphics/esquerda.png"),
    ball = love.graphics.newImage("graphics/ball.png") 
  }

    -- Sounds
    sounds =  {
        wall_hit = love.audio.newSource('sounds/Wall.mp3', 'static'),
        player_hit = love.audio.newSource('sounds/Paddle.wav', 'static'),
        theme = love.audio.newSource('sounds/Tema_Em_E.wav', 'static'),
        score = love.audio.newSource('sounds/Score.wav', 'static')
    }

   
    -- Plays main soundtrack in a loop
    sounds.theme:setLooping(true)
    sounds.theme:setVolume(1/3)
    sounds.theme:play()
    
    
    -- Pontuação
    player1_score = 0
    player2_score = 0

    -- serving state
    serving_player = 1

    --Winner
    winning_player = 0
    
    -- Iniciar player 1 e 2 como "Paddles"
    player1 = Paddle(20, WINDOW_HEIGHT/2 - sprites.esquerda:getHeight()/2, sprites.esquerda)
    player2 = Paddle(WINDOW_WIDTH - 20 - sprites.direita:getWidth(), 
        WINDOW_HEIGHT/2 - sprites.direita:getHeight()/2, 
        sprites.direita
    )

    -- Iniciando a bola como "Ball"
    ball = Ball()

    -- Posição inicial da bola
    ball_x = WINDOW_WIDTH/2 - sprites.ball:getWidth()/2
    ball_y = WINDOW_HEIGHT/2 - sprites.ball:getHeight()/2

    -- Velocidade da bola
    ball_speed = 300

    -- Direction of our ball
    ball_direction = math.random(360)

    -- X and Y velocities of our ball
    ball_dx, ball_dy = velocity(ball_speed, ball_direction)

    -- Estado do jogo
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
    
    -- If we are in the play state, update our ball
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
    
    if game_state == 'play' then
        -- detect ball collision with paddles, changing de direction of the ball if true and
        -- slightly increasing its speed
        if ball:collides(player1) then
            -- plays sounds effect
            sounds.player_hit:play()

            ball.speed = ball.speed * 1.05
            ball.x = player1.x + player1.width

            -- Aleatorizando a direção do rebatimento
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

            -- Aleatorizando a direção do rebatimento
            if ball.dy < 0 then
                ball.direction = math.random(200, 250)
            else
                ball.direction = math.random(110, 160)
            end

            ball.dx, ball.dy = velocity(ball.speed, ball.direction)
        end


        -- Colisão com as bordas
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
        -- Colisão com as bordas esquerda e direita (pontuação)
        if ball.x + ball.width < 0 then
            -- player2 scored
            -- plays sound effect
            sounds.score:play()

            player2_score = player2_score + 1
            ball:reset()
            serving_player = 1
            game_state = 'serve'
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
            ball:reset()
            serving_player = 2
            game_state = 'serve'
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

function love.draw()
   -- Desenhando as imagens
       
      -- background
      love.graphics.setColor(1, 1, 1, 0.5)
      love.graphics.draw(background, WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 0, 1/2.1, 1/2.1,
      background:getWidth()/2, background:getHeight()/2)
      love.graphics.setColor(1, 1, 1, 1)
 
  -- Draws different things depending on the state of the game
  if game_state == 'start' then

   love.graphics.draw(titulo, WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 0, 1/2, 1/2, titulo:getWidth()/2, titulo:getHeight()/2)
  else
    -- Pontos
   love.graphics.setFont(glitch_font)
   love.graphics.printf(player1_score, 20, 20, WINDOW_WIDTH/2 - 100, 'left')
   love.graphics.printf(player2_score, WINDOW_WIDTH/2 + 100, 20, WINDOW_WIDTH/2 - 120, 'right')

   love.graphics.setFont(glitch_font2)
      
      if game_state == 'serve' then
          love.graphics.printf('Player ' .. serving_player .. ' is serving', 0, 60, WINDOW_WIDTH, 'center')
          love.graphics.printf('press enter to serve', 0, 80, WINDOW_WIDTH, 'center')
      elseif game_state == 'done' then
          love.graphics.setFont(glitch_font)
          love.graphics.printf('player ' .. winning_player .. ' has won', 0, WINDOW_HEIGHT/2 - 20, WINDOW_WIDTH, 'center')
          love.graphics.setFont(glitch_font2)
          love.graphics.printf('press enter to restart', 0, WINDOW_HEIGHT/2 + 20, WINDOW_WIDTH, 'center')
      end

      -- Renders ball
      if game_state == 'serve' then
        ball:render()
      elseif game_state == 'play' then
        ball:render()
      end

      -- Renders players's paddles
      player1:render()   
      player2:render()
  end
end
