-- Allows for live console output
io.stdout:setvbuf('no')

function love.load()

    -- Set fullscreen mode
    love.window.setMode(0, 0, { fullscreen = true }) 

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

    -- Walls
    wallLeft = 50
    wallRight = 350
    floorY = love.graphics.getHeight() - 50 -- Floor positioned near the bottom

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

    -- Collision with walls
    if ball.x - ball.radius < wallLeft then
        ball.x = wallLeft + ball.radius
        ball.speedX = -ball.speedX * ball.restitution
    elseif ball.x + ball.radius > wallRight then
        ball.x = wallRight - ball.radius
        ball.speedX = -ball.speedX * ball.restitution
    end

    -- Collision with floor
    if ball.y + ball.radius > floorY then
        ball.y = floorY - ball.radius
        ball.speedY = -ball.speedY * ball.restitution
    end

    -- Collision with pins
    for _, pin in ipairs(pins) do
        local dx = ball.x - pin.x
        local dy = ball.y - pin.y
        local distance = math.sqrt(dx * dx + dy * dy)
        local minDist = ball.radius + pin.radius

        if distance < minDist then
            -- Calculate normal vector
            local nx, ny = dx / distance, dy / distance
            -- Reflect velocity
            local dot = ball.speedX * nx + ball.speedY * ny
            ball.speedX = ball.speedX - 2 * dot * nx
            ball.speedY = ball.speedY - 2 * dot * ny
            -- Apply restitution
            ball.speedX = ball.speedX * ball.restitution
            ball.speedY = ball.speedY * ball.restitution
            -- Move ball out of collision
            ball.x = pin.x + nx * minDist
            ball.y = pin.y + ny * minDist
        end
    end
end

function love.draw()
    -- Draw walls
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", wallLeft - 5, 0, 10, love.graphics.getHeight()) -- Left wall
    love.graphics.rectangle("fill", wallRight - 5, 0, 10, love.graphics.getHeight()) -- Right wall
    love.graphics.rectangle("fill", wallLeft, floorY, wallRight - wallLeft, 10) -- Floor

    -- Draw ball
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", ball.x, ball.y, ball.radius)

    -- Draw pins
    love.graphics.setColor(0, 0, 1)
    for _, pin in ipairs(pins) do
        love.graphics.circle("fill", pin.x, pin.y, pin.radius)
    end
end
