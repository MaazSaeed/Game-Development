PauseState = Class{__includes = BaseState}

function PauseState:init()
    self.previousState = nil
end

function PauseState:enter(params)
    sounds['music']:stop()
    sounds['pause']:play()
    self.previousState = params
end

function PauseState:update(dt)
    if love.keyboard.wasPressed('p') then
        sounds['unpause']:play()
        sounds['music']:play()
        gStateMachine:change('play', self.previousState)
    end
end

function PauseState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Paused!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press P to continue...' , 0, 100, VIRTUAL_WIDTH, 'center')
end