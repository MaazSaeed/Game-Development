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

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

scrolling = true

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

-- note that the Bird class needs to be called after VIRTUAL WIDTH and HEIGHT are declared 
local bird = Bird() 

local pipePairs = {}

local spawnTimer = 0

-- we don't want the heights of the pipes (where they are spawning in the y axis) to be completely random
-- so we spawn them at the top of the screen, the +20 ensures that the 
local lastY = -PIPE_HEIGHT + math.random(80) + 20

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
    
    for k, pair in pairs(pipePairs) do
        pair:render()
    end
    
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    bird:render()

    push:finish()
end

function love.resize(w, h)
    push:resize(w,h)
end

function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

        spawnTimer = spawnTimer + dt

        if spawnTimer > 3 then
            -- copied the comments as they were
            -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
            -- no higher than 10 pixels below the top edge of the screen,
            -- and no lower than a gap length (90 pixels) from the bottom
            local y = math.max(-PIPE_HEIGHT + 10,
                math.min(lastY + math.random(-40, 40), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            
            lastY = y

            table.insert(pipePairs, PipePair(y))
            
            spawnTimer = 0
        end
        
        
        bird:update(dt)
        
        for k, pair in pairs(pipePairs) do
            pair:update(dt)


            for l, pipe in pairs(pair.pipes) do
                if bird:collides(pipe) then
                    scrolling = false
                end
            end

            if pair.x < -PIPE_WIDTH then 
                pair.remove = true
            end
        end

            -- Previously:
            -- pipe is outside the left side of the screen
            -- if pipe.x < -pipe.width then
            --     table.remove(pipes, k)
            -- end

            -- Now:
        for k, pair in pairs(pipePairs) do
            if pair.remove then
                table.remove(pipePairs, k)
            end
        end
        
        love.keyboard.keysPressed = {} -- resetting it to prepare for the next time space is pressed
    end
end
