PlayerThrowPotState = Class{__includes = EntityIdleState}

function PlayerThrowPotState:enter(params)

end

function PlayerThrowPotState:update(dt)
    self.entity:changeAnimation('pot-throw-' .. self.entity.direction)
    Timer.after(0.3, function () self.entity:changeState('idle') end)
end