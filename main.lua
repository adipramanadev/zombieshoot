function love.load()
    love.window.setTitle('Zombie Shooter')
    sprites = {}
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')
    sprites.background = love.graphics.newImage('sprites/background.png')

    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.speed = 180
    tempRotation = 0
end

function love.update(dt)
    if love.keyboard.isDown("d") then player.x = player.x + player.speed * dt end
    if love.keyboard.isDown("a") then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("w") then player.y = player.y - player.speed * dt end
    if love.keyboard.isDown("s") then player.y = player.y + player.speed * dt end
    tempRotation = tempRotation + 0.01
end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0)
    love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(),
                       nil, nil, sprites.player:getWidth() / 2,
                       sprites.player:getHeight() / 2)
end

-- function playerMouseAngle() deprecated
--      return math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x) + math.pi 
-- end

-- function playerMouseAngle() deprecated
--     local dx = love.mouse.getX() - player.x
--     local dy = love.mouse.getY() - player.y
--     return math.atan2(dy, dx) -- Gunakan math.atan2 untuk menghitung sudut yang benar
-- end

function playerMouseAngle()
    local dx = love.mouse.getX() - player.x
    local dy = love.mouse.getY() - player.y
    local angle = math.atan(dy / dx)
    -- Adjust the angle based on the quadrant
    if dx < 0 then
        angle = angle + math.pi
    end

    return angle
end


