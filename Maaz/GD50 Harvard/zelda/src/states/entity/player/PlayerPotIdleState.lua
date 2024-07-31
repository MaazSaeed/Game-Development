
PlayerPotIdleState = Class{__includes = EntityIdleState}

function PlayerPotIdleState:enter(params)

end

function PlayerPotIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('carry-pot')
    end

    self.entity:changeAnimation('pot-idle-' .. self.entity.direction)

    if love.keyboard.wasPressed('space') then
        self.entity:resetPot({x = self.entity.x, y = self.entity.y})
        self.entity.holdingPot:throw(self.entity.direction)
        self.entity:changeState('pot-throw')
        gSounds['throw-pot']:play()
    end
end