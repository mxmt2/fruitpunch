--[[
    Michelle Tan
    CS50x 2020 Final Project

    Fruit Punch.

    This is a game inspired by Atari's Breakout and Blackberry's Brick Breaker.
    
    Graphics taken from:
    https://opengameart.org/content/pixel-hearts
    https://kenney.nl/assets/space-shooter-redux
    https://kenney.nl/assets/game-icons

    Sound effects taken from:
    Bfxr
    https://opengameart.org/content/100-plus-game-sound-effects-wavoggm4a

]]

push = require 'push'
Class = require 'class'

require 'Map'
require 'Paddle'
require 'Ball'
require 'Powerup'
require 'Laser'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 324
VIRTUAL_HEIGHT = 243


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fruit Punch')
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- initialise fonts
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    largeFont = love.graphics.newFont('fonts/font.ttf', 12)

    -- initialise lives and powerup variables
    lives = 3
    level = 1
    MAX_LEVEL = 5
    powerupTotal = 0
    powerupCount = 0
    powerups = {}
    laserActive = false

    -- initialise gameState
    gameState = 'start'

    -- initialise map
    map = Map()

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'enter' or key == 'return' or key == 'space' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'death' then
            love.gameReset()
            gameState = 'start'
        elseif gameState == 'level complete' then
            love.nextLevel()
            gameState = 'serve'
        elseif gameState == 'play' then
            if laserActive == true and map.laser.shooting == false then
                map.laser.shooting = true 
                map.laser.x = map.paddle.x + map.paddle.width / 2 - map.laser.width / 2
                map.laser.y = VIRTUAL_HEIGHT - map.laser.height
                map.laser.sounds['shoot']:stop()
                map.laser.sounds['shoot']:play()
            end
        end
    end
end


function love.update(dt)
    map:update(dt)
end


--[[
    CUSTOM FUNCTIONS
]]
-- resets the game
function love.gameReset()
    lives = 3
    level = 1 
    powerupTotal = 0
    powerupCount = 0
    powerups = {}
    laserActive = false

    map = Map()
end

-- brings you to the next level and reloads map
function love.nextLevel()
    level = level + 1

    map = Map()
    powerupChance = false
end


function love.draw()
    push:apply('start')

    love.graphics.clear(22/255, 22/255, 22/255, 1)

    -- print number of lives on top left-hand corner
    love.graphics.setFont(smallFont)
    love.graphics.print("Lives: " .. tostring(lives), 10, 10)
    love.graphics.print("Level " .. tostring(level), VIRTUAL_WIDTH - 40, 10)
    
    if gameState == 'start' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('This is Fruit Punch.', 0, 15, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter or Space to start.', 0, 30, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then 
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter or Space to serve the ball.', 0, 15, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Use the left and right arrow keys to move the paddle.', 0, 25, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then

    elseif gameState == 'death' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('GAME OVER', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter or Space to restart.', 0, 25, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'level complete' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Level complete!', 0, 15, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter or Space to progress to the next level.', 0, 25, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'victory' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('WATERMELON SUGAR', 0, 30, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('HIGH', 0, 45, VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(smallFont)
        love.graphics.printf('Congratulations, you finished the game!', 0, 85, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("You're one in a melon!", 0, 95, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Thanks for playing, we're so grapeful for your support!", 0, 105, VIRTUAL_WIDTH, 'center')

        love.graphics.printf('This was CS50.', 0, 205, VIRTUAL_WIDTH, 'center')
    end

    map:render()

    push:apply('end')
end


