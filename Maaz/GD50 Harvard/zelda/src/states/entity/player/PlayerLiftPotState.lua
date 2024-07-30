PlayerLiftPotState = Class{__includes = EntityIdleState}


function PlayerLiftPotState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
end

function PlayerLiftPotState:enter(params)
end

function PlayerLiftPotState:update(dt)
    self.entity:changeAnimation('pot-lift-' .. self.entity.direction)
    
    Timer.after(0.25, function () self.entity:changeState('carry-pot') end)
end