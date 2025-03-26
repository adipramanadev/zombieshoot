function love.load()
    math.randomseed(os.time())
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
    myFont = love.graphics.newFont(40)
    zombies = {}
    bullets = {}
    gamestate = 1
    score = 0
    maxTime = 2
    timer = maxTime

    -- tambahkan health player
    player.health = 3
    player.injured = false
end

function love.update(dt)
    if gamestate == 2 then
        if love.keyboard.isDown("d") and player.x < love.graphics.getWidth() then
            player.x = player.x + player.speed * dt
        end
        if love.keyboard.isDown("a") and player.x > 0 then
            player.x = player.x - player.speed * dt
        end
        if love.keyboard.isDown("w") and player.y > 0 then
            player.y = player.y - player.speed * dt
        end
        if love.keyboard.isDown("s") and player.y < love.graphics.getHeight() then
            player.y = player.y + player.speed * dt
        end
    end
    for i, z in ipairs(zombies) do
        z.x = z.x + math.cos(zombiePlayerAngle(z)) * z.speed * dt
        z.y = z.y + math.sin(zombiePlayerAngle(z)) * z.speed * dt

        if distanceBetween(z.x, z.y, player.x, player.y) < 30 then
            if player.health > 1 then
                player.health = player.health - 1
                table.remove(zombies, i)
                -- for i, z in ipairs(zombies) do
                --     zombies[i] = nil
                --     gamestate = 1
                -- end
            else
                player.health = player.health - 1
                player.injured = true
                gamestate = 0
                break
            end

        end
    end

    for i, b in ipairs(bullets) do
        b.x = b.x + math.cos(b.direction) * b.speed * dt
        b.y = b.y + math.sin(b.direction) * b.speed * dt
    end

    for i = #bullets, 1, -1 do
        local b = bullets[i]
        if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y >
            love.graphics.getHeight() then table.remove(bullets, i) end
    end

    for i, z in ipairs(zombies) do
        for j, b in ipairs(bullets) do
            if distanceBetween(z.x, z.y, b.x, b.y) < 20 then
                z.dead = true
                b.dead = true
                score = score + 1
            end
        end
    end

    for i = #zombies, 1, -1 do
        local z = zombies[i]
        if z.dead == true then table.remove(zombies, i) end
    end

    for i = #bullets, 1, -1 do
        local b = bullets[i]
        if b.dead == true then table.remove(bullets, i) end
    end

    if gamestate == 2 then
        timer = timer - dt
        if timer <= 0 then
            spawnZombie()
            maxTime = 0.95 * maxTime
            timer = maxTime
        end
    end
end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0)
    if gamestate == 1 then
        love.graphics.setFont(myFont)
        love.graphics.printf("Click anywhere to begin!", 0, 50,
                             love.graphics.getWidth(), "center")
    end
    if gamestate == 0 then
        love.graphics.setFont(myFont)
        love.graphics.printf("Game Over", 0, love.graphics.getHeight() / 2 - 20, love.graphics.getWidth(), "center")
        love.graphics.printf("Final Score: " .. score, 0, love.graphics.getHeight() / 2 + 20, love.graphics.getWidth(), "center")
        return  -- Stop drawing other things when game is over
    end
    love.graphics.printf("Score: " .. score, 0, love.graphics.getHeight() - 100,
                         love.graphics.getWidth(), "center")
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

    -- display health player
    love.graphics.setFont(myFont)
    love.graphics.printf("Health: " .. player.health, 0,
                         love.graphics.getHeight() - 50,
                         love.graphics.getWidth(), "center")
end

function love.keypressed(key)
    if key == "space" and gamestate == 2 then spawnZombie() end

end

function love.mousepressed(x, y, button)
    if button == 1 and gamestate == 2 then
        spawnBullet()
    elseif button == 1 and gamestate == 1 then
        gamestate = 2
        maxTime = 2
        timer = maxTime
        score = 0
        player.health = 3
        player.x = love.graphics.getWidth() / 2
        player.y = love.graphics.getHeight() / 2
        zombies = {}
        bullets = {}
    elseif button == 1 and gamestate == 0 then
         -- Restart the game after game over
         gamestate = 2
         maxTime = 2
         timer = maxTime
         score = 0
         player.health = 3  -- Reset health
         player.x = love.graphics.getWidth() / 2
         player.y = love.graphics.getHeight() / 2
         zombies = {}
         bullets = {}
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
    local side = math.random(1, 4)
    if side == 1 then
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 3 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -30
    elseif side == 4 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 30
    end
    zombie.speed = 140
    zombie.dead = false
    table.insert(zombies, zombie)
end

function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 500
    bullet.dead = false
    bullet.direction = playerMouseAngle()
    table.insert(bullets, bullet)
end

function distanceBetween(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy) -- Euclidean distance formula
end
