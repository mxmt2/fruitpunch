--[[
    Powerup class

    Each time a block is hit an RNG will determine whether a powerup spawns or not, so long as 
    the number of powerups generated in that level is less than 6 (this is defined in Map.lua)
    and another RNG will determine which type of powerup will spawn (defined under initialise).
    
    After a powerup spawns it will slowly drop towards the bottom 
    If a powerup is caught, then the function defined for each powerup under self.behaviours will
    run, effecting the powerup. For laser, this will be linked to a global variable and the shooting 
    will be defined under Map.lua. All powerup effects will reset on losing a life or completing the 
    level (exception: the laser powerup can be carried over to the next level). 
]]

require 'Util'

Powerup = Class{}

--[[
    GOOD
    extra life
    longer paddle
    slower ball
    laser gun

    BAD
    slower paddle
    shorter paddle
    faster ball 
]]

function Powerup:init()

    self.x = 0
    self.y = 0
    self.poweruptype = 'life'
    self.speed = 50
    self.falling = false

    -- sound effects when powerups are caught
    self.sounds = {
        ['powerupGood'] = love.audio.newSource('sounds/powerupGood.wav', 'static'),
        ['powerupBad'] = love.audio.newSource('sounds/powerupBad.ogg', 'static')
    }

    -- initialise the types of powerups
    self.types = {

        -- for the RNG initialising powerups below
        [1] = 'life',
        [2] = 'fastball',
        [3] = 'slowball',
        [4] = 'fastpaddle',
        [5] = 'slowpaddle',
        [6] = 'lengthen',
        [7] = 'shorten',
        [8] = 'laser',

        -- graphics for each powerup
        ['life'] = {
            texture = love.graphics.newImage('graphics/pixelhearts.png'),
            sprite = love.graphics.newQuad(0, 0, 36, 32, 112, 32),
            active = false,
            x = 0,
            y = 0,
            scalex = 0.25,
            scaley = 0.25,
            width = 36 * 0.25,
            height = 32 * 0.25,
            draw = function() 
                love.graphics.draw(self.types['life'].texture, self.types['life'].sprite, 
                self.types['life'].x, self.types['life'].y, 0, 
                self.types['life'].scalex, self.types['life'].scaley)
            end   
        },

        ['fastball'] = {
            texture = love.graphics.newImage('graphics/fast.png'),
            active = false,
            x = 0, 
            y = 0, 
            scalex = 0.1,
            scaley = 0.1,
            width = 100 * 0.1,
            height = 100 * 0.1,
            draw = function()
                love.graphics.draw(self.types['fastball'].texture, self.types['fastball'].x,
                self.types['fastball'].y, 0, self.types['fastball'].scalex, 
                self.types['fastball'].scaley)
            end
        },

        ['slowball'] = {
            texture = love.graphics.newImage('graphics/slow.png'),
            active = false,
            x = 0, 
            y = 0, 
            scalex = 0.115,
            scaley = 0.115,
            width = 100 * 0.115,
            height = 100 * 0.115,
            draw = function()
                love.graphics.draw(self.types['slowball'].texture, self.types['slowball'].x,
                self.types['slowball'].y, 0, self.types['slowball'].scalex, 
                self.types['slowball'].scaley)
            end
        },

        ['fastpaddle'] = {
            texture = love.graphics.newImage('graphics/fastPaddle.png'),
            active = false,
            x = 0, 
            y = 0, 
            scalex = 0.1,
            scaley = 0.1,
            width = 100 * 0.1,
            height = 100 * 0.1,
            draw = function()
                love.graphics.draw(self.types['fastpaddle'].texture, self.types['fastpaddle'].x,
                self.types['fastpaddle'].y, 0, self.types['fastpaddle'].scalex, 
                self.types['fastpaddle'].scaley)
            end
        },

        ['slowpaddle'] = {
            texture = love.graphics.newImage('graphics/slowPaddle.png'),
            active = false,
            x = 0, 
            y = 0, 
            scalex = 0.115,
            scaley = 0.115,
            width = 100 * 0.115,
            height = 100 * 0.115,
            draw = function()
                love.graphics.draw(self.types['slowpaddle'].texture, self.types['slowpaddle'].x,
                self.types['slowpaddle'].y, 0, self.types['slowpaddle'].scalex, 
                self.types['slowpaddle'].scaley)
            end
        },

        ['lengthen'] = {
            texture = love.graphics.newImage('graphics/lengthen.png'),
            active = false,
            x = 0, 
            y = 0, 
            scalex = 0.15,
            scaley = 0.15,
            width = 100 * 0.15,
            height = 100 * 0.15,
            draw = function()
                love.graphics.draw(self.types['lengthen'].texture, self.types['lengthen'].x,
                self.types['lengthen'].y, 0, self.types['lengthen'].scalex, 
                self.types['lengthen'].scaley)
            end
        },

        ['shorten'] = {
            texture = love.graphics.newImage('graphics/shorten.png'),
            active = false,
            x = 0, 
            y = 0, 
            scalex = 0.15,
            scaley = 0.15,
            width = 100 * 0.15,
            height = 100 * 0.15,
            draw = function()
                love.graphics.draw(self.types['shorten'].texture, self.types['shorten'].x,
                self.types['shorten'].y, 0, self.types['shorten'].scalex, 
                self.types['shorten'].scaley)
            end
        },

        ['laser'] = {
            texture = love.graphics.newImage('graphics/lightning.png'),
            active = false,
            x = 0, 
            y = 0, 
            scalex = 0.35,
            scaley = 0.35,
            width = 19 * 0.35,
            height = 30 * 0.35,
            draw = function()
                love.graphics.draw(self.types['laser'].texture, self.types['laser'].x,
                self.types['laser'].y, 0, self.types['laser'].scalex, 
                self.types['laser'].scaley)
            end
        }
    }

    -- behaviour map for each powerup type
    self.behaviours = {

        ['life'] = function()
            self.sounds['powerupGood']:stop()
            self.sounds['powerupGood']:play()

            if self.types['life'].active == true then
                lives = lives + 1
                self.types['life'].active = false
            end
        end,

        ['fastball'] = function()
            self.sounds['powerupBad']:stop()
            self.sounds['powerupBad']:play()

            if self.types['fastball'].active == true then
                if map.ball.dx > 0 then
                    map.ball.dx = math.min(map.ball.dx * 1.75, 175)
                else
                    map.ball.dx = math.max(map.ball.dx * 1.75, -175)
                end
                if map.ball.dy > 0 then
                    map.ball.dy = math.min(map.ball.dy * 1.75, 175)
                else
                    map.ball.dy = math.max(map.ball.dy * 1.75, -175)
                end
                self.types['fastball'].active = false
            end
        end,

        ['slowball'] = function()
            self.sounds['powerupGood']:stop()
            self.sounds['powerupGood']:play()

            if self.types['slowball'].active == true then
                if map.ball.dx > 0 then
                    map.ball.dx = math.max(map.ball.dx * 0.7, 20)
                else 
                    map.ball.dx = math.min(map.ball.dx * 0.7, -25)
                end
                if map.ball.dy > 0 then
                    map.ball.dy = math.max(map.ball.dy * 0.7, 20)
                else
                    map.ball.dy = math.max(map.ball.dy * 0.7, -20)
                end
                self.types['slowball'].active = false
            end
        end,

        ['fastpaddle'] = function()
            self.sounds['powerupGood']:stop()
            self.sounds['powerupGood']:play()

            if self.types['fastpaddle'].active == true then
                map.paddle.speed = math.min(map.paddle.speed + 75, 225)
                self.types['fastpaddle'].active = false
            end
        end,

        ['slowpaddle'] = function()
            self.sounds['powerupBad']:stop()
            self.sounds['powerupBad']:play()

            if self.types['slowpaddle'].active == true then
                map.paddle.speed = math.max(75, map.paddle.speed - 75)
                self.types['slowpaddle'].active = false
            end
        end,

        ['lengthen'] = function()
            self.sounds['powerupGood']:stop()
            self.sounds['powerupGood']:play()

            if self.types['lengthen'].active == true then
                if map.paddle.width < 55 then
                    map.paddle.width = map.paddle.width + 10
                    map.paddle.x = map.paddle.x - 5
                end
                self.types['lengthen'].active = false
            end
        end,

        ['shorten'] = function()
            self.sounds['powerupBad']:stop()
            self.sounds['powerupBad']:play()

            if self.types['shorten'].active == true then
                if map.paddle.width > 35 then
                    map.paddle.width = map.paddle.width - 10
                    map.paddle.x = map.paddle.x + 5
                end
                self.types['shorten'].active = false
            end
        end,

        ['laser'] = function()
            self.sounds['powerupGood']:stop()
            self.sounds['powerupGood']:play()

            if self.types['laser'].active == true then
                laserActive = true
                self.types['laser'].active = false
            end
        end
    }
end


function Powerup:update(dt)

    if self.falling == true then 
        
        -- powerup drops down
        self.types[self.poweruptype].y = self.types[self.poweruptype].y + self.speed * dt

        -- if powerup is not caught
        if self:caughtPowerup() then
            self.falling = false
            self.behaviours[self.poweruptype]()
        elseif self.types[self.poweruptype].y > VIRTUAL_HEIGHT 
        or map.ball.y > VIRTUAL_HEIGHT + map.ball.r or gameState == 'level complete' then
            self.types[self.poweruptype].active = false
            self.falling = false
        end
    end

end

-- will be called when powerup spawns
function Powerup:initialise()

    -- random chance of spawning each type of powerup
    self.poweruptype = self.types[math.random(8)]

    self.types[self.poweruptype].x = self.x - self.types[self.poweruptype].width / 2
    self.types[self.poweruptype].y = self.y - self.types[self.poweruptype].height / 2 
    self.types[self.poweruptype].active = true
    self.falling = true

end


-- checks if the powerup was caught by player
function Powerup:caughtPowerup()

    if self.types[self.poweruptype].x <= map.paddle.x + map.paddle.width 
    and self.types[self.poweruptype].x + self.types[self.poweruptype].width >= map.paddle.x
    and self.types[self.poweruptype].y + self.types[self.poweruptype].height >= map.paddle.y then
        return true
    end

    return false
end


function Powerup:render()

    if self.types[self.poweruptype].active == true then 
        self.types[self.poweruptype].draw()
    end
    
end

