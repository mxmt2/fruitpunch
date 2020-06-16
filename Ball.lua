--[[ 
    Implements the ball and implements functions 
    checking for collision with blocks and paddle
]]

Ball = Class{}

-- x,y is the coordinates of the centre of the ball
-- r is the radius of the ball
function Ball:init(map)
    
    self.map = map
    self.r = 3

    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT - self.r - 5

    self.dx = math.random(2) == 1 and math.random(-20, -60) or math.random(20, 60)
    self.dy = -120

end

function Ball:update(dt)

    self:blockCollide()
        
        -- bouncing the ball off the left and right boundaries
        if self.dx < 0 then
            self.x = math.max(self.r, self.x + self.dx * dt)
            if self.x == self.r then
                self.map.sounds['ballHit']:stop()
                self.map.sounds['ballHit']:play()
                self.dx = -self.dx
            end
        elseif self.dx > 0 then
            self.x = math.min(VIRTUAL_WIDTH - self.r, self.x + self.dx * dt)
            if self.x == VIRTUAL_WIDTH - self.r then
                self.map.sounds['ballHit']:stop()
                self.map.sounds['ballHit']:play()
                self.dx = -self.dx
            end
        end

        -- bouncing the ball off the top of the screen
        if self.dy < 0 then
            self.y = math.max(self.r, self.y + self.dy * dt)
            if self.y == self.r then
                self.map.sounds['ballHit']:stop()
                self.map.sounds['ballHit']:play()
                self.dy = -self.dy
            end
        elseif self.dy > 0 then
            self.y = self.y + self.dy * dt
        end
end


--[[
    CUSTOM FUNCTIONS
]]

-- called when gameState == serve, places ball on top of paddle and resets speed
function Ball:reset(paddle)
    self.x = paddle.x + paddle.width / 2 
    self.y = paddle.y - self.r
    self.dx = math.random(2) == 1 and math.random(-40, -100) or math.random(40, 100)
    self.dy = -120
end

-- checks collision with paddle
function Ball:paddleCollides(paddle)
    if self.x - self.r <= paddle.x + paddle.width and self.x + self.r >= paddle.x
    and self.y + self.r >= paddle.y then
        return true
    end
end

-- checks collision with blocks
-- also calls the function to check if powerup is spawned
function Ball:blockCollide()
    -- checking up/down collisions
    if self.map:tileAt(self.x, self.y + self.r).id ~= nil or
    self.map:tileAt(self.x, self.y - self.r).id ~= nil then
        self.dy = -self.dy
        self.map.sounds["blockHit"]:stop()
        self.map.sounds["blockHit"]:play()

        -- removing block
        if self.map:tileAt(self.x, self.y + self.r).id == 1 then
            self.map:removeTile(self.x, self.y + self.r)

            -- chance to spawn a powerup
            self.map:spawnPowerup(math.floor(self.x / self.map.blockWidth),
            math.floor((self.y + self.r)/ self.map.blockHeight))

            self.y = math.floor((self.y + self.r)/ self.map.blockHeight) * map.blockHeight - self.r 

        -- changing block
        elseif self.map:tileAt(self.x, self.y + self.r).id ~= nil then
            self.map:changeTile(self.x, self.y + self.r)

            self.y = math.floor((self.y + self.r)/ self.map.blockHeight) * map.blockHeight - self.r 

        -- removing block
        elseif self.map:tileAt(self.x, self.y - self.r).id == 1 then
            self.map:removeTile(self.x, self.y - self.r)

            -- chance to spawn a powerup
            self.map:spawnPowerup(math.floor(self.x / self.map.blockWidth),
            math.floor((self.y - self.r)/ self.map.blockHeight))

            self.y = math.floor((self.y - self.r)/ self.map.blockHeight) * map.blockHeight 
            + map.blockHeight + self.r

        -- changing block
        elseif self.map:tileAt(self.x, self.y - self.r).id ~= nil then
            self.map:changeTile(self.x, self.y - self.r)

            self.y = math.floor((self.y - self.r)/ self.map.blockHeight) * map.blockHeight 
            + map.blockHeight + self.r
        end
    end
    
    -- checking left/right collisions
    
    if self.map:tileAt(self.x + self.r, self.y).id ~= nil or
    self.map:tileAt(self.x - self.r, self.y).id ~= nil then
        self.dx = - self.dx
        self.map.sounds["blockHit"]:stop()
        self.map.sounds["blockHit"]:play()

        -- removing block
        if self.map:tileAt(self.x + self.r, self.y).id == 1 then
            self.map:removeTile(self.x + self.r, self.y)
            
            -- chance to spawn powerup
            self.map:spawnPowerup(math.floor((self.x + self.r) / self.map.blockWidth), 
            math.floor(self.y / self.map.blockHeight))

            self.x = math.floor((self.x + self.r) / self.map.blockWidth) * self.map.blockWidth 
            - self.r 

        -- changing block
        elseif self.map:tileAt(self.x + self.r, self.y).id ~= nil then
            self.map:changeTile(self.x + self.r, self.y)

            self.x = math.floor((self.x + self.r) / self.map.blockWidth) * self.map.blockWidth 
            - self.r 

        -- removing block
        elseif self.map:tileAt(self.x - self.r, self.y).id == 1 then
            self.map:removeTile(self.x - self.r, self.y)

            -- chance to spawn powerup
            self.map:spawnPowerup(math.floor((self.x - self.r) / self.map.blockWidth), 
            math.floor(self.y / self.map.blockHeight))

            self.x = math.floor((self.x - self.r) / self.map.blockWidth) * self.map.blockWidth 
            + self.r + self.map.blockWidth
        
        -- changing block
        elseif self.map:tileAt(self.x - self.r, self.y).id ~= nil then
            self.map:changeTile(self.x - self.r, self.y)

            self.x = math.floor((self.x - self.r) / self.map.blockWidth) * self.map.blockWidth 
            + self.r + self.map.blockWidth
        end
    end

end

-- checking if ball falls below the screen
function Ball:death()
    if self.y - self.r > VIRTUAL_HEIGHT then
        return true
    end
end

function Ball:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', self.x, self.y, self.r, 12)
end

