--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]

function ScoreState:enter(params)
    self.score = params.score
    self.gold = love.graphics.newImage('medal_01.png')
    self.silver = love.graphics.newImage('medal_02.png')
    self.bronze = love.graphics.newImage('medal_03.png')
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    if self.score < 5 then
        love.graphics.draw(self.bronze, VIRTUAL_WIDTH / 2 - 5, VIRTUAL_HEIGHT / 2 - 5)
    elseif self.score > 5 and self.score < 10 then
        love.graphics.draw(self.silver, 0, 0)
    else
        love.graphics.draw(self.gold, 0, 0)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end