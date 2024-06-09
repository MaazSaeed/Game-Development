--[[
1. set up basic variables and functions (load, draw, resize, widths, heights, etc)
2. Load images
3. Create parallax scrolling (variables and love.update)
4. Add Bird class
5. Introduce gravity using dy
6. Introduce bottom pipe
7. Introduce top pipe as a pair
8. Collision Update
9. State Machine
10. Scoring
11. Countdown update
12. Sound effects
        ADDITIONAL/ASSIGNMENT
13. Mouse Feature
14. Pause State
15. 
16. 


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
require 'states/CountdownState'

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
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountdownState() end
        }
        
    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }
    
    sounds['music']:setLooping(true)
    sounds['music']:play()
                
    gStateMachine:change('title')

    -- initialize the input table
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
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

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    
    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    if not scrolling then
        love.graphics.setFont(flappyFont)
        love.graphics.printf('Paused', 0, VIRTUAL_HEIGHT / 2 - 28, VIRTUAL_WIDTH, 'center')
        
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Press r to resume', 0, VIRTUAL_HEIGHT / 2 + 20, VIRTUAL_WIDTH, 'center')
    end
    
    push:finish()
end

function love.resize(w, h)
    push:resize(w,h)
end

function love.update(dt)
    if love.keyboard.wasPressed('p') then
        scrolling = false
    end

    if love.keyboard.wasPressed('r') then
        scrolling = true
    end

    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

        gStateMachine:update(dt)
    
        love.keyboard.keysPressed = {} -- resetting it to prepare for the next time space is pressed
        
        love.mouse.buttonsPressed = {}
    end
end
