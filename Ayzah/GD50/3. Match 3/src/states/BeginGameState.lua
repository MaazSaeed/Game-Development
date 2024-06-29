BeginGameState = Class{__includes = BaseState}

function BeginGameState:init(def)
    -- start transition alpha at full to fade in
    self.transitionAlpha = 1

    -- board on the right side of screen
    self.board = Board(VIRTUAL_WIDTH - 272, 16)

    -- start level # label off-screen
    self.levelLabelY = -64
end

function BeginGameState:enter(def)
    self.level = def.level

    -- 1. fade out in one second
    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })
    :finish(function()
        -- 2. text label to center of screen
        Timer.tween(0.25, 
        {
            [self] = {levelLabelY = VIRTUAL_HEIGHT / 2 - 8}
        })
            :finish(function()
                -- 3. one second pause
                Timer.after(1, function()
                    -- 4. label goes past bottom
                    Timer.tween(0.25, {
                        [self] = {levelLabelY = VIRTUAL_HEIGHT + 30}
                    })
                    :finish(function()
                        gStateMachine:change('play',
                    {
                        level = self.level,
                        board = self.board
                    })
                end)
            end)
        end)
    end)
end


function BeginGameState:update(dt) 
    Timer.update(dt)
end

function BeginGameState:render() 
    self.board:render()

    love.graphics.setColor(95/255, 205/255, 228/255, 200/255)
    love.graphics.rectangle('fill', 0, self.levelLabelY - 8, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level),
        0, self.levelLabelY, VIRTUAL_WIDTH, 'center')
        
    -- transition foreground rectangle
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        
end
