Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.holdingPot = nil
    self.isTweening = false  -- Flag to check if the tweening is in progress
    self.tweeningFinished = false
    self.hasPot = false
end

function Player:update(dt)
    Entity.update(self, dt)

    if self.hasPot and not self.isTweening then
        self.isTweening = true 
        Timer.tween(0.27, {
            [self.holdingPot] = {x = self.x, y = self.y - self.width / 2}
        }):finish(function()
            self.tweeningFinished = true
        end)
    end
end

function Player:changeState(name)
    Entity.changeState(self, name)
end

function Player:resetPot(pos)
    self.hasPot = false
    self.isTweening = false
    self.tweeningFinished = false


    --self.holdingPot:throw()
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:render()
    Entity.render(self)

    -- after the pot lift animation has been finished i.e., the tweeningFinished flag is set,
    -- we will display the pot relative to the player position, as pot's initial x and y are fixed
    if self.hasPot and not self.tweeningFinished then
        love.graphics.draw(gTextures[self.holdingPot.texture], 
            gFrames[self.holdingPot.texture][self.holdingPot.frame], 
            self.holdingPot.x, self.holdingPot.y)
    elseif self.hasPot and self.tweeningFinished then
        love.graphics.draw(gTextures[self.holdingPot.texture], 
        gFrames[self.holdingPot.texture][self.holdingPot.frame], 
        self.x, self.y - self.width / 2)
        self.holdingPot.x = self.x
        self.holdingPot.y = self.y - self.width / 2
    end

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end