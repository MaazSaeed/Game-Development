PlayerCarryPotState = Class{__includes = EntityWalkState}

function PlayerCarryPotState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
        -- render offset for spaced character sprite; negated in render function of state
        self.entity.offsetY = 5
        self.entity.offsetX = 0
end

function PlayerCarryPotState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('pot-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('pot-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('pot-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('pot-down')
    else
        self.entity:changeAnimation('pot-idle-'..self.entity.direction)
        if love.keyboard.wasPressed('space') then
            self.entity:resetPot({x = self.entity.x, y = self.entity.y})
            self.entity.holdingPot:throw(self.entity.direction)
            self.entity:changeState('pot-throw')
            gSounds['throw-pot']:play()
        end
        return 
    end

    if love.keyboard.wasPressed('space') then
        self.entity:resetPot({x = self.entity.x, y = self.entity.y})
        self.entity.holdingPot:throw(self.entity.direction)
        self.entity:changeState('pot-throw')
        gSounds['throw-pot']:play()
    end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

    -- if we bumped something when checking collision, check any object collisions
    if self.bumped then
        if self.entity.direction == 'left' then
            
            -- temporarily adjust position into the wall, since bumping pushes outward
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-left')
                end
            end

            -- readjust
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'right' then
            
            -- temporarily adjust position
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-right')
                end
            end

            -- readjust
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'up' then
            
            -- temporarily adjust position
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-up')
                end
            end

            -- readjust
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
        else
            
            -- temporarily adjust position
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-down')
                end
            end

            -- readjust
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
        end
    end
end