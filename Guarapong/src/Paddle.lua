--[[
    Puella Magi Pong Magica

    Paddle Class -
    Represents a paddle that can move up and down. Used in the main
    program to deflect the ball back toward the opponent.
]]

Paddle = Class{}

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
function Paddle:init(x, y, sprite)
    self.x = x
    self.y = y
    self.sprite = sprite

    self.width = self.sprite:getWidth()
    self.height = self.sprite:getHeight()
    self.dy = 0
end

-- To be called in love.update(dt) in main.lua. Contains the logic for the paddles.
function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(WINDOW_HEIGHT - self.height, self.y + self.dy * dt)
    end
end


-- To be called in love.draw() in main.lua. Draws the paddle based on it's sprite and position
function Paddle:render()
    love.graphics.draw(self.sprite, self.x, self.y)
end