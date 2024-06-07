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

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

-- parallax scroll
local BACKGROUND_SCROLL_SPEED = 30 -- background moves slower
local GROUND_SCROLL_SPEED = 60 -- double the speed of background

local BACKGROUND_LOOPING_POINT = 413 -- repeating at 413

-- note that the Bird class needs to be called after VIRTUAL WIDTH and HEIGHT are declared 
local bird = Bird() -- local ensures the variable cannot be used in other files

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fifty Bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
    {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

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

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

    push:finish()
    
end

function love.resize(w, h)
    push:resize(w,h)
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    bird:update(dt)

    love.keyboard.keysPressed = {} -- resetting it to prepare for the next time space is pressed
end
