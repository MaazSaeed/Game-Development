ScoreState = Class{__includes = BaseState}

local NOOB = love.graphics.newImage('noob.png')
local MID = love.graphics.newImage('mid.png')
local PRO = love.graphics.newImage('pro.png')

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.mouse.wasPressed(1) then
        sounds['jump']:play()
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('OH NO! You lost :(', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to play again :D', 0, 160, VIRTUAL_WIDTH, 'center')

    if self.score < 5 then
        love.graphics.draw(NOOB, VIRTUAL_WIDTH/2 - 20, 200)
    end

    if self.score > 5 and self.score < 10 then
        love.graphics.draw(MID, VIRTUAL_WIDTH/2 - 20, 200)
    end

    if self.score > 10 then
        love.graphics.draw(PRO, VIRTUAL_WIDTH/2 - 20, 200)
    end
end
