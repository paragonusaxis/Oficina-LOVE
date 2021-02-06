--[[
    Puella Magi Pong Magica

    Ball Class -
    Represents a ball which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.
]]

Ball = Class{}

--[[
    The `init` function on our class is called just once, when the object
    is first created. Used to set up all variables in the class and get it
    ready for use.

    Our Paddle should take an X and a Y, for positioning, as well as a width
    and height for its dimensions.

    Note that `self` is a reference to *this* object, whichever object is
    instantiated at the time this function is called. Different objects can
    have their own x, y, width, and height values, thus serving as containers
    for data.
]]
function Ball:init()
    self.sprite = sprites.ball

    self.width = self.sprite:getWidth()
    self.height = self.sprite:getHeight()

    self.x = WINDOW_WIDTH/2 - self.width/2
    self.y = WINDOW_HEIGHT/2 - self.height/2

    self.speed = 500
    self.direction = math.random(360)
    self.dx, self.dy = velocity(self.speed, self.direction)
end

--[[
    Expects a paddle as an argument and returns true or false, depending
    on whether their rectangles overlap.
]]
function Ball:collides(paddle)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x < paddle.x + paddle.width and self.x + self.width > paddle.x and 
    self.y < paddle.y + paddle.height and self.y + self.height > paddle.y then
        return true
    else
        return false
    end
end

--[[
    Places the ball in the middle of the screen, with a random direction.
]]
function Ball:reset()
    self.speed = 500
    self.x = WINDOW_WIDTH / 2 - self.width/2
    self.y = WINDOW_HEIGHT / 2 - self.height/2
    self.direction = math.random(360)
    self.dx, self.dy = velocity(self.speed, self.direction)
end

--[[
    To be called in love.update(dt) in main.lua. Contains the logic for the ball.
    Simply applies velocity to position, scaled by deltaTime.
]]
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

-- To be called in love.draw() in main.lua. Draws the ball based on it's sprite and position
function Ball:render()
    love.graphics.draw(self.sprite, self.x, self.y)
end