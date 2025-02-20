-- Allows for live console output
io.stdout:setvbuf('no')

function love.load()
    ball = {
        x = 200,
        y = 100,
        radius = 20,
        speedY = 0, -- Vertical speed
        gravity = 500 -- Pixels per second squared
    }
end

function love.update(dt)
     -- Apply gravity
    ball.speedY = ball.speedY + ball.gravity * dt
    ball.y = ball.y + ball.speedY * dt

    -- Stop the ball at the bottom of the screen (basic collision)
    if ball.y + ball.radius > love.graphics.getHeight() then
        ball.y = love.graphics.getHeight() - ball.radius
        ball.speedY = 0
    end
end

function love.draw()
    love.graphics.circle("fill", ball.x, ball.y, ball.radius)
end