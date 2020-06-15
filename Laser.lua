Laser = Class{}

function Laser:init(map)

    self.map = map
    self.x = 0
    self.y = 0
    self.dy = -150
    self.scalex = 0.4
    self.scaley = 0.4
    self.width = 13 * self.scalex
    self.height = 54 * self.scaley

    self.texture = love.graphics.newImage('graphics/laser.png')

    self.sounds = {
        ['shoot'] = love.audio.newSource('sounds/laser.ogg', 'static'),
        ['hit'] = love.audio.newSource('sounds/laserHit.wav', 'static')
    }

    self.sounds['hit']:setVolume(0.7)

    self.shooting = false

end


function Laser:update(dt)

    -- laser moves upwards
    if self.shooting == true then
        self.y = self.y + self.dy * dt
        if self.y <= -self.height then
            self.shooting = false
        end
    end

    self:blockHit()

    if laserActive == false then
        self.shooting = false
        self.x = 0
        self.y = 0
    end

end


-- checks if the laser hits a block
function Laser:blockHit()

    if self.map:tileAt(self.x + self.width / 2, self.y).id ~= nil then
        self.shooting = false
        self.sounds["hit"]:stop()
        self.sounds["hit"]:play()

        -- removing block
        if self.map:tileAt(self.x + self.width / 2, self.y).id == 1 then
            self.map:removeTile(self.x + self.width / 2, self.y)

            -- chance to spawn a powerup
            self.map:spawnPowerup(math.floor((self.x + self.width / 2) / self.map.blockWidth),
            math.floor(self.y / self.map.blockHeight))

        -- changing block
        elseif self.map:tileAt(self.x + self.width / 2, self.y).id ~= nil then
            self.map:changeTile(self.x + self.width / 2, self.y)
        end
    end

end



function Laser:render()
    if laserActive == true then
        love.graphics.printf('Press Space to shoot.', 0, 25, VIRTUAL_WIDTH, 'center')
        if self.shooting == true then
            love.graphics.draw(self.texture, self.x, self.y, 0, self.scalex, self.scaley)
        end
    end
end
