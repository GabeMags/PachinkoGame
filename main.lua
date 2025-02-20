-- Allows for live console output
io.stdout:setvbuf('no')

function love.load()
    -- Ball properties
    ball = {
        x = 200,
        y = 50,
        radius = 10,
        speedX = 0,
        speedY = 0,
        gravity = 500,
        restitution = 0.6 -- Bounciness factor
    }

    -- Stationary circles (pins)
    pins = {
        {x = 150, y = 300, radius = 10},
        {x = 250, y = 400, radius = 10},
        {x = 201, y = 500, radius = 10},
        {x = 100, y = 600, radius = 10},
        {x = 300, y = 700, radius = 10}
    }
end

function love.update(dt)
    -- Apply gravity
    ball.speedY = ball.speedY + ball.gravity * dt
    ball.y = ball.y + ball.speedY * dt
    ball.x = ball.x + ball.speedX * dt

    -- Collision with the ground
    if ball.y + ball.radius > love.graphics.getHeight() then
        ball.y = love.graphics.getHeight() - ball.radius
        ball.speedY = -ball.speedY * ball.restitution
    end

    -- Collision with pins
    for _, pin in ipairs(pins) do
        local dx = ball.x - pin.x
        local dy = ball.y - pin.y
        local distance = math.sqrt(dx * dx + dy * dy)
        local minDistance = ball.radius + pin.radius

        if distance < minDistance then
            -- Normalize the collision normal
            local nx, ny = dx / distance, dy / distance

            -- Reflect velocity
            local dotProduct = ball.speedX * nx + ball.speedY * ny
            ball.speedX = ball.speedX - 2 * dotProduct * nx
            ball.speedY = ball.speedY - 2 * dotProduct * ny

            -- Apply restitution
            ball.speedX = ball.speedX * ball.restitution
            ball.speedY = ball.speedY * ball.restitution

            -- Move the ball out of the pin to prevent sticking
            ball.x = pin.x + nx * minDistance
            ball.y = pin.y + ny * minDistance
        end
    end
end

function love.draw()
    -- Draw the ball
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", ball.x, ball.y, ball.radius)

    -- Draw the pins
    love.graphics.setColor(0, 0, 1)
    for _, pin in ipairs(pins) do
        love.graphics.circle("fill", pin.x, pin.y, pin.radius)
    end
end
