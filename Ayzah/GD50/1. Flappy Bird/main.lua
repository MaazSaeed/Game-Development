--[[
1. set up basic variables and functions (load, draw, resize, widths, heights, etc)
2. Load images
3. Create parallax scrolling (variables and love.update)
4. Add Bird class
5. Introduce gravity using dy



bird image taken from: https://pngtree.com/freepng/cute-blue-and-yellow-bird-sticker-design-clipart-vector_12234090.html
]]

push = require 'push'

Class = require 'class'

require 'Bird'

require 'Pipe'

require 'PipePair'

require 'StateMachine'

require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- local ensures the variable cannot be used in other files
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

-- parallax scroll
local BACKGROUND_SCROLL_SPEED = 30 -- background moves slower
local GROUND_SCROLL_SPEED = 60 -- double the speed of background

local BACKGROUND_LOOPING_POINT = 413 -- repeating at 413

local GROUND_LOOPING_POINT = 514

local scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fifty Bird')

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
    {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine{
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    -- initialize the input table
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    -- keeping a record of the keys pressed since we can't call this function in other files.
    -- Those files will refer to this table to find out if a key has been pressed :p
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] -- returns true or false
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    
    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end

function love.resize(w, h)
    push:resize(w,h)
end

function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

        gStateMachine:update(dt)
    
        love.keyboard.keysPressed = {} -- resetting it to prepare for the next time space is pressed
    end
end
