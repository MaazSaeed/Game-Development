EntityDeadState = Class{__includes = BaseState}

function EntityDeadState:init(entity)
    self.entity = entity
end


function EntityDeadState:enter(params)
    self.entity.dead = true
    if math.random(2) == 1 then
        Event.dispatch('spawn-heart', self.entity)
    end
end

function EntityDeadState:exit()

end


function EntityDeadState:update()

end