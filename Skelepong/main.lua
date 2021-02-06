--Constante
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600
Class =require 'lib/class'
require 'src/constants'
require 'src/utils'
require 'src/Paddle'
require 'src/Ball'

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  -- Configurações da tela
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = false,
      resizable = false,
      vsync = 1
    })
  
  -- Titulo da janela
  love.window.setTitle ("Skelepong")
  
  math.randomseed(os.time())
  
  --Fontes
  bones_font = love.graphics.newFont("fonts/bones&roses.ttf", 22)
  
  --Sprites
  sprites = {
    osso1 = love.graphics.newImage("graphics/osso esquerdo.png"),
    osso2 = love.graphics.newImage("graphics/osso direito.png"),
    ball = love.graphics.newImage("graphics/caveirao.png"),
    skelepong = love.graphics.newImage("graphics/skelepong.png")
  }
  
  --Sons
  sounds = {
    player_hit=love.audio.newSource('sounds/Batida de osso.wav','static'),
    score=love.audio.newSource('sounds/ponto.wav','static')
    }
  
  -- Variavel dos pontos
  player1_points = 0
  player2_points = 0
  
  --Determina quem saca, no caso o player 1
  serving_player =1
  
  winning_player =0
  
  -- Inicializa os players como pasinhas
  player1 = Paddle(20, WINDOW_HEIGHT/2 -sprites.osso1:getHeight()/2, sprites.osso1)
  player2 = Paddle(WINDOW_WIDTH - 20 -sprites.osso2:getWidth()/2, WINDOW_HEIGHT/2 - sprites.osso2:getHeight()/2, sprites.osso2)
  
  --Inicializa a bolinha
  ball = Ball()
  
  game_state= 'start'
  
end
-- A cada frame do game
function love.update(dt)
  
  --Player 1 movimento
  if love.keyboard.isDown('w') then
    player1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    player1.dy = PADDLE_SPEED
  else
    player1.dy = 0
  end
  
  --Player2
  if love.keyboard.isDown('up') then
    player2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    player2.dy = PADDLE_SPEED
  else
    player2.dy = 0
  end
  
  --Update nas pasinhas
  player1:update(dt)
  player2:update(dt)
  
  if game_state == 'serve' then
    ball.speed = math.random(400,450)
    if serving_player == 1 then
      ball.direction = math.random (-45,45)
    else
      ball.direction = math.random (135,225)
    end
    ball.dx, ball.dy = velocity(ball.speed, ball.direction)
  end
  
  
  
  --Verificar colisão da bolinha
  if game_state == 'play'then
    if ball:collides(player1) then
      sounds.player_hit:play()
      
      ball.speed = ball.speed * 1.10
      ball.x = player1.x + player1.width
      
      --randomiza direção
      if ball.dy < 0 then
        ball.direction = math.random(300,350)
      else
        ball.direction = math.random(20,70)
      end
      ball.dx, ball.dy = velocity(ball.speed, ball.direction)
    end
    if ball:collides(player2) then
      sounds.player_hit:play()
      
      ball.speed = ball.speed*1.05
      ball.x = player2.x - ball.width
      if ball.dy<0 then
        ball.direction =math.random (200,250)
      else
        ball.direction = math.random (110,160)
      end
      ball.dx, ball.dy =velocity(ball.speed, ball.direction)
    end
    if ball.y <=0 then
      sounds.player_hit:play()
      
      ball.y = 0
      ball.dy = -ball.dy
    end
    if ball.y >= WINDOW_HEIGHT -ball.height then
      sounds.player_hit:play()
      ball.y = WINDOW_HEIGHT -ball.height
      ball.dy = -ball.dy
    end
    if ball.x + ball.width<0 then
      --Ponto player 2
      sounds.score:play()
      player2_points = player2_points+1
      serving_player=1
      if player2_points==10 then
        winning_player=2
        game_state='done'
      else
        ball:reset()
        game_state='serve'
      end
    end
    if ball.x> WINDOW_WIDTH then
      sounds.score:play()
      player1_points =player1_points+1
      serving_player = 2
      if player1_points ==10 then
        winning_player=1
        game_state='done'
      else
        ball:reset()
        game_state='serve'
      end
    end
    
      
    ball:update(dt)
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if game_state == 'start' then
      game_state = 'serve'
    elseif game_state=='serve' then
      game_state = 'play'
    elseif game_state=='done' then
      game_state='serve'
      
      ball:reset()
      player1_points=0
      player2_points=0
    end
  end
end

      
        
    
function love.draw()
  if game_state=='start' then
    love.graphics.setFont(bones_font)
    love.graphics.printf('skelepong',0, WINDOW_HEIGHT/2 -40,WINDOW_WIDTH,'center')
    love.graphics.printf('aperte enter pra jogar',0, WINDOW_HEIGHT/2 +40,WINDOW_WIDTH, 'center')
    else
  love.graphics.setFont(bones_font)
  love.graphics.printf('skelepong',0,20, WINDOW_WIDTH, 'center')
  love.graphics.printf(player1_points,20,20, WINDOW_WIDTH/2 -100, 'left')
  love.graphics.printf(player2_points, WINDOW_WIDTH/2 +100,20, WINDOW_WIDTH/2 -120, 'right')
  
  if game_state=='serve' then
    love.graphics.printf('jogador'..serving_player..' saca',0,100,WINDOW_WIDTH,'center')
    love.graphics.printf(" aperte enter para sacar",0,140,WINDOW_WIDTH,'center')
  elseif game_state=='done'then
    love.graphics.printf( 'jogador '..winning_player..' ganhou!',0, WINDOW_HEIGHT/2 -40,WINDOW_WIDTH, 'center')
    love.graphics.printf( "aperte enter pra jogar novamente",0,  WINDOW_HEIGHT/2 +40,WINDOW_WIDTH, 'center')
    end
    
  --[[if game_state == 'start' then
    love.graphics.printf('start state',0,100, WINDOW_WIDTH, 'center')
  elseif game_state == 'play' then
    love.graphics.printf('play state',0,100, WINDOW_WIDTH, 'center')
  end]]
  ball:render()
  player1:render()
  player2:render()
end

  --[[love.graphics.draw(osso1, 0, 175)
  
  love.graphics.draw(osso2, 770, 175)
  
  love.graphics.draw(caveira, WINDOW_WIDTH/2, WINDOW_HEIGHT/2)]]
  
 
   end   