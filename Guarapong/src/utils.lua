--[[
    This file holds useful functions that will be used in our game
    ]]

-- this function calculates x and y velocities based in a vector with a speed and a direction
function velocity (speed, direction)
    rad = math.rad(direction) 
    dx = speed * math.cos(rad)
    dy = speed * math.sin(rad)

    return dx, dy
end


--Renders the current FPS.
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('fps: ' .. love.timer.getFPS(), 20, WINDOW_HEIGHT - 40)
end