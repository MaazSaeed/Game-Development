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

        -- resuming the game from where the player left off, including the pipes, score and lastY of the pipe
        gStateMachine:change('play', self.previousState)
    end
end

function PauseState:render()
    for k, pair in pairs(self.previousState.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.previousState.score), 8, 8)

    self.previousState.bird:render()

    love.graphics.setFont(flappyFont)
    love.graphics.printf('Paused!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press P to continue...' , 0, 100, VIRTUAL_WIDTH, 'center')
end