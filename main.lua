-- Allows for live console output
io.stdout:setvbuf('no')


-- Begin code
function love.draw()
    love.graphics.print("Hello World", 400, 300)
end