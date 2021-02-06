
Bola= Class{}


function Bola:init()
    self.sprite = sprites.bola

    self.width = self.sprite:getWidth()
    self.height = self.sprite:getHeight()

    self.x = WINDOW_WIDTH/2 - self.width/2
    self.y = WINDOW_HEIGHT/2 - self.height/2

    self.speed = 300
    self.direction = math.random(360)
    self.dx, self.dy = velocity(self.speed, self.direction)
end

function Bola:collides(paddle)
    if self.x < paddle.x + paddle.width and self.x +self.width > paddle.x and
    self.y < paddle.y + paddle.height and self.y +self.height > paddle.y then
        return true
    else
        return false
    end
end

--Primeiro no centro, depois vai p direções aleatorias, reseta e vai de volta
function Bola:reset()
    self.x = WINDOW_WIDTH / 2 - self.width/2
    self.y = WINDOW_HEIGHT / 2 - self.height/2

end

function Bola:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Bola:render()
    love.graphics.draw(self.sprite, self.x, self.y)
end