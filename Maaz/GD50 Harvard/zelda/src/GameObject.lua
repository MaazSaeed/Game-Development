GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    -- whether the object can be consumed by the player e.g., to gain health, powerup etc.
    self.consumable = def.consumable

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function() end

    self.dx = 0
    self.dy = 0
end

function GameObject:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function GameObject:throw(dir)
    if dir == 'left' then
        self.dx = -THROW_THRUST
        self.dy = 0
    elseif dir == 'right' then
        self.dx = THROW_THRUST
        self.dy = 0
    elseif dir == 'up' then
        self.dx = 0
        self.dy = -THROW_THRUST
    elseif dir == 'down' then
        self.dx = 0
        self.dy = THROW_THRUST
    end
end


function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.state and self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end
