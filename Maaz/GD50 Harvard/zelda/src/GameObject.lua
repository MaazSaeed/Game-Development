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

    self.destroy = false

    self.distanceTravelled = 0
    self.projectile = false
    
end

function GameObject:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.projectile then
        self.distanceTravelled = self.distanceTravelled + THROW_THRUST * dt
    end
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

    self.projectile = true
end

function GameObject:destroy()
    self.destroy = true
end

function GameObject:collidesWithBoundaries()
    if self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE or
       self.x + self.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 or
       self.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2 or
       self.y + self.height >= VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE
       then
        return true
    end     
end

-- check if an entity is in the proximity of the given game object
function GameObject:nearHitBox(entity)
    return entity.x + entity.width >= self.x - 5 and entity.x <= self.x + self.width + 5 and
           entity.y + entity.height >= self.y - 5 and entity.y - entity.height <= self.y + self.height + 5
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.state and self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end
