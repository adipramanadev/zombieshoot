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
    zombies = {}
    bullets = {}
    gamestate = 1
end

function love.update(dt)
    if love.keyboard.isDown("d") then player.x = player.x + player.speed * dt end
    if love.keyboard.isDown("a") then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("w") then player.y = player.y - player.speed * dt end
    if love.keyboard.isDown("s") then player.y = player.y + player.speed * dt end

    for i, z in ipairs(zombies) do
        z.x = z.x + math.cos(zombiePlayerAngle(z)) * z.speed * dt
        z.y = z.y + math.sin(zombiePlayerAngle(z)) * z.speed * dt

        if distanceBetween(z.x, z.y, player.x, player.y) < 30 then
            for i, z in ipairs(zombies) do zombies[i] = nil end
        end
    end

    for i, b in ipairs(bullets) do
        b.x = b.x + math.cos(b.direction) * b.speed * dt
        b.y = b.y + math.sin(b.direction) * b.speed * dt
    end
end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0)
    love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(),
                       nil, nil, sprites.player:getWidth() / 2,
                       sprites.player:getHeight() / 2)
    for i, z in ipairs(zombies) do
        love.graphics.draw(sprites.zombie, z.x, z.y, zombiePlayerAngle(z), nil,
                           nil, sprites.zombie:getWidth() / 2,
                           sprites.zombie:getHeight() / 2)
    end

    for i, b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x, b.y, nil, 0.5, 0.5,
                           sprites.bullet:getWidth() / 2,
                           sprites.bullet:getHeight() / 2)
    end
end

function love.keypressed(key)
    if key == "space" then
        spawnZombie()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        spawnBullet()
    end
end

function playerMouseAngle()
    local dx = love.mouse.getX() - player.x
    local dy = love.mouse.getY() - player.y
    local angle = math.atan(dy / dx)
    -- Adjust the angle based on the quadrant
    if dx < 0 then angle = angle + math.pi end

    return angle
end

function zombiePlayerAngle(enemy)
    local dx = player.x - enemy.x
    local dy = player.y - enemy.y
    local angle = math.atan(dy / dx)

    -- Handle the different quadrants:
    if dx < 0 then
        angle = angle + math.pi -- Adjust angle when dx is negative (for the second and third quadrants)
    end
    -- Handle the case when dx is zero (divide by zero protection):
    if dx == 0 then
        if dy > 0 then
            angle = math.pi / 2 -- Straight up
        elseif dy < 0 then
            angle = -math.pi / 2 -- Straight down
        end
    end

    return angle
end

function spawnZombie()
    local zombie = {}
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = math.random(0, love.graphics.getHeight())
    zombie.speed = 140

    table.insert(zombies, zombie)
end

function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 500
    bullet.direction = playerMouseAngle()
    table.insert(bullets, bullet)
end

function distanceBetween(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy) -- Euclidean distance formula
end
