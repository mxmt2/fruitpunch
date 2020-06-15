--[[
    Sets the blocks for each level and
    contains the ball, paddle and powerups
]]

require 'Util'

Map = Class{}

function Map:init()
    
    -- initialise ball and paddle
    self.ball = Ball(self)
    self.paddle = Paddle(self)

    self.mapWidth = 15      -- use 2 - 14
    self.mapHeight = 14     -- use 4 - 12
    self.blockWidth = 21.5
    self.blockHeight = 15

    -- initialise powerups
    powerupChance = false
    powerupLevel = 6
    powerupTotal = powerupTotal + powerupLevel
    for i = 1 + (powerupTotal - powerupLevel), powerupTotal do
        powerups[i] = Powerup()
    end
    laserActive = false
    self.laser = Laser(self)

    -- initialise the tiles
    self.tiles = {}

    -- Level 1: apple
    if level == 1 then
        local y = 4
        self:setTile(8, y, 2)
        self:setTile(9, y, 5)
        self:setTile(10, y, 5)

        y = y + 1
        self:setTile(8, y, 2)
        self:setTile(9, y, 5)

        y = y + 1
        self:setTile(6, y, 1)
        self:setTile(7, y, 1)
        self:setTile(8, y, 2)
        self:setTile(9, y, 1)
        self:setTile(10, y, 1)

        for y = 7, 11 do
            for x = 5, 11 do
                self:setTile(x, y, 1)
            end
        end

        local y = 12
        for x = 6, 10 do
            self:setTile(x, y, 1)
        end

        y = y + 1
        for x = 7, 9 do
            self:setTile(x, y, 1)
        end
    end

    -- Level 2: pineapple
    if level == 2 then 
        local y = 4
        self:setTile(7, y, 6)
        self:setTile(9, y, 6)

        y = y + 1
        for x = 6, 10 do
            self:setTile(x, y, 6)
        end

        y = y + 1
        self:setTile(7, y, 3)
        self:setTile(8, y, 4)
        self:setTile(9, y, 3)

        for y = 7, 11 do 
            for x = 6, 10 do 
                if y % 2 ~= 0 then
                    if x % 2 == 0 then
                        self:setTile(x, y, 3)
                    else
                        self:setTile(x, y, 4)
                    end
                else
                    if x % 2 == 0 then
                        self:setTile(x, y, 4)
                    else
                        self:setTile(x, y, 3)
                    end
                end
            end
        end

        local y = 12
        self:setTile(7, y, 3)
        self:setTile(8, y, 4)
        self:setTile(9, y, 3)
    end

    -- Level 3: watermelon
    if level == 3 then
        local y = 5 
        self:setTile(3, y, 6)
        self:setTile(13, y, 6)
        for x = 4, 12 do
            self:setTile(x, y, 1)
        end

        y = y + 1
        self:setTile(3, y, 6)
        self:setTile(13, y, 6)
        self:setTile(4, y, 1)
        self:setTile(12, y, 1)
        for x = 6, 10 do
            self:setTile(x, y, 1)
        end

        y = y + 1
        self:setTile(3, y, 6)
        self:setTile(13, y, 6)
        for x = 4, 7 do
            self:setTile(x, y, 1)
        end
        for x = 9, 12 do
            self:setTile(x, y, 1)
        end

        y = y + 1 
        self:setTile(4, y, 6)
        self:setTile(12, y, 6)
        self:setTile(5, y, 1)
        self:setTile(11, y, 1)
        for x = 7, 9 do
            self:setTile(x, y, 1)
        end

        y = y + 1
        self:setTile(5, y, 6)
        self:setTile(11, y, 6)
        for x = 6, 10 do
            self:setTile(x, y, 1)
        end

        y = y + 1
        for x = 6, 10 do
            self:setTile(x, y, 6)
        end
    end

    -- Level 4: grapes
    if level == 4 then
        local y = 4
        self:setTile(7, y, 6)
        self:setTile(8, y, 2)

        y = y + 1
        self:setTile(6, y, 6)
        for x = 7, 9 do 
            self:setTile(x, y, 2)
        end

        y = y + 1
        self:setTile(7, y, 8)
        self:setTile(8, y, 2)
        self:setTile(9, y, 8)
        self:setTile(10, y, 8)

        y = y + 1
        for x = 6, 10 do 
            self:setTile(x, y, 8)
        end

        y = y + 1
        for x = 6, 9 do 
            self:setTile(x, y, 8)
        end
        
        for y = 9, 10 do 
            for x = 7, 9 do 
                self:setTile(x, y, 8)
            end
        end

        self:setTile(8, 11, 8)
        self:setTile(9, 11, 8)
        self:setTile(8, 12, 8)
    end

    -- Level 5: peach
    if level == 5 then
        local y = 4
        self:setTile(6, y, 6)
        self:setTile(7, y, 6)

        y = y + 1
        for x = 5, 8 do
            self:setTile(x, y, 6)
        end

        y = y + 1
        for x = 4, 6 do
            self:setTile(x, y, 6)
        end
        for x = 7, 10 do
            self:setTile(x, y, 7)
        end

        y = y + 1
        self:setTile(4, y, 6)
        self:setTile(5, y, 6)
        for x = 6, 11 do
            self:setTile(x, y, 7)
        end

        for y = 8, 11 do
            for x = 5, 11 do
                self:setTile(x, y, 7)
            end
        end

        local y = 12
        for x = 6, 10 do
            self:setTile(x, y, 7)
        end

        y = y + 1
        for x = 7, 9 do
            self:setTile(x, y, 7)
        end

        self:setTile(8, 14, 7)
    end

    -- tester level
    -- if level == 9 then
    --     self:setTile(6, 6, 1)
    --     self:setTile(7, 6, 1)
    -- end 

    -- initialise sounds 
    self.sounds = {
        ['ballHit'] = love.audio.newSource('sounds/ballHit.wav', 'static'),
        ['blockHit'] = love.audio.newSource('sounds/blockHit.wav', 'static'),
        ['lifeLost'] = love.audio.newSource('sounds/life_lost.wav', 'static'),
        ['levelComplete'] = love.audio.newSource('sounds/levelComplete.wav', 'static'),
        ['gameOver'] = love.audio.newSource('sounds/gameOver.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static')
    }

end


function Map:update(dt)

    if gameState == 'play' then
        self.ball:update(dt)
        self.paddle:update(dt)

        if laserActive == true then
            self.laser:update(dt)
        end

        for i = 1, powerupTotal do
            if powerups[i].active == true then
                powerups[i]:update(dt)
            end
        end

        -- the angle which the ball deflects off the paddle is propotional to
        -- how close the ball is to the centre of the paddle
        if self.ball:paddleCollides(self.paddle) and self.ball.dy > 0 then
            self.sounds['ballHit']:stop()
            self.sounds['ballHit']:play()
            self.ball.dy = -self.ball.dy * 1.02
            self.ball.dx = ((self.ball.x - self.paddle.centre) / (self.paddle.width / 2)) * 120
            self.ball.y = self.paddle.y - self.ball.r
        end

        if self.ball:death() then
            gameState = 'life lost'
            self.sounds['lifeLost']:play()
            laserActive = false
            self.laser.shooting = false
            lives = lives - 1
        end

        if self:checkWin() then
            if level ~= MAX_LEVEL then
                self.sounds['levelComplete']:play()
                gameState = 'level complete'
                self.laser.shooting = false
            else 
                gameState = 'victory'
                self.sounds['victory']:play()
            end
        end
    end

    -- if player still has lives left, serve again
    if gameState == 'life lost' and lives > 0 then
        gameState = 'serve'
        -- if paddle speed was changed by a powerup remove the effect
        if self.paddle.speed ~= 150 then
            self.paddle.speed = 150
        end
        -- if paddle width was changed by a powerup remove the effect
        if self.paddle.width ~= 45 then
            self.paddle.width = 45
        end
        self.ball:reset(self.paddle)
    
    -- if player has no lives left, game over
    elseif gameState == 'life lost' and lives == 0 then
        self.sounds["gameOver"]:play()
        gameState = 'death'
    end
        
end


--[[
    CUSTOM FUNCTIONS
]]

-- gets the tile type at a given pixel coordinate
function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.blockWidth) + 1,
        y = math.floor(y / self.blockHeight) + 1,
        id = self:getTile(math.floor(x / self.blockWidth) + 1, math.floor(y / self.blockHeight) + 1)
    }
end

-- returns an integer value for the tile at a given x-y coordinate
function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

-- sets a tile at a given x-y coordinate to an integer value
function Map:setTile(x, y, blockValue)
    self.tiles[(y - 1) * self.mapWidth + x] = blockValue
end

-- checks whether a level has been completed
function Map:checkWin()
    for y = 4, self.mapHeight do
        for x = 2, self.mapWidth do
            if self:getTile(x, y) ~= nil then
                return false
            end
        end
    end
    return true
end

-- when ball hits a red block it disappears
function Map:removeTile(x, y)
    self:setTile(math.floor(x / self.blockWidth) + 1,
    math.floor(y / self.blockHeight) + 1, nil)
end

-- when ball hits a block that is not red it will change colour
function Map:changeTile(x, y)
    local blockValue = self:tileAt(x, y).id
    self:setTile(math.floor(x / self.blockWidth) + 1, 
    math.floor(y / self.blockHeight) + 1, blockValue - 1)
end

-- chance to spawn powerup
-- initialises the powerup itself
function Map:spawnPowerup(x, y)
    if math.random(10 + powerupCount) == 1 then
        powerupChance = true
        powerupCount = powerupCount + 1
        if powerupCount <= powerupTotal then
            powerups[powerupCount].active = true
            powerups[powerupCount].x = x * map.blockWidth + map.blockWidth / 2
            powerups[powerupCount].y = y * map.blockHeight + map.blockHeight / 2
            powerups[powerupCount]:initialise()
            powerupChance = false
        else 
            powerupChance = false
        end
    else
        powerupChance = false
    end
end


function Map:render()
    
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            BLOCK_TYPE = self:getTile(x, y)
            -- setting colours for each block

            -- red
            if BLOCK_TYPE == 1 then
                love.graphics.setColor(193 / 255, 40 / 255, 50 / 155, 1)
            
            -- brown
            elseif BLOCK_TYPE == 2 then
                love.graphics.setColor(195 / 255, 128 / 255, 100 / 255, 1)

            -- light yellow
            elseif BLOCK_TYPE == 3 then 
                love.graphics.setColor(235 / 255, 235 / 255, 126 / 255, 1)

            -- orange
            elseif BLOCK_TYPE == 4 then
                love.graphics.setColor(230 / 255, 190 / 255, 114 / 255, 1)

            -- light green
            elseif BLOCK_TYPE == 5 then 
                love.graphics.setColor(150 / 255, 227 / 255, 10 / 255, 1)

            -- green
            elseif BLOCK_TYPE == 6 then 
                love.graphics.setColor(85 / 255, 135 / 255, 86 / 255, 1)

            -- pink
            elseif BLOCK_TYPE == 7 then 
                love.graphics.setColor(253 / 255, 170 / 255, 152 / 255, 1)

            -- purple
            elseif BLOCK_TYPE == 8 then 
                love.graphics.setColor(180 / 255, 108 / 255, 255 / 255, 1)

            end

            if BLOCK_TYPE ~= nil then
                love.graphics.rectangle('fill', (x - 1) * self.blockWidth, 
                (y - 1) * self.blockHeight, self.blockWidth - 1, self.blockHeight - 1)
            end

        end
    end

    self.paddle:render()
    self.ball:render()

    for i = 1, powerupTotal do
        if powerups[i].active == true then
            powerups[i]:render()
        end
    end

    if laserActive == true then
        self.laser:render()
    end


end

