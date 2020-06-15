--[[
    Implements the paddle, which is controlled by the player
]]

Paddle = Class{}


function Paddle:init(map)
    
    self.map = map
    self.speed = 150
    self.width = 45
    self.height = 5
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT - self.height
    self.rx = 2
    self.ry = 2
    self.dx = 0

end


-- use left and right arrow keys to move the ball
function Paddle:update(dt)
    if love.keyboard.isDown('left') then
        self.dx = -self.speed
        self.x = math.max(0, self.x + self.dx * dt)
    elseif love.keyboard.isDown('right') then
        self.dx = self.speed
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    else
        self.dx = 0
    end

    -- used to calculate distance between ball and centre of paddle 
    self.centre = self.x + self.width / 2
end


function Paddle:render()
    love.graphics.setColor(50/255, 100/255, 210/255, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, self.rx, self.ry)
end

