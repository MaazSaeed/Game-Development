--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.width = def.width
    self.height = def.height
    self.frame = def.frame
    self.solid = def.solid
    self.collidable = def.collidable
    self.consumable = def.consumable
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.hit = def.hit
    self.refOther = def.refOther or nil
    self.show = not (def.texture == 'flags-posts' or def.texture == 'flags')
    self.flag = def.flag or nil

    self.animation = def.animation or nil
end

function GameObject:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function GameObject:update(dt)
    if self.animation ~= nil then
        self.animation:update(dt)
    end
end

function GameObject:render()
    if self.show then
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)    
        if self.flag then
            love.graphics.draw(gTextures[self.texture], gFrames[self.flag][self.animation:getCurrentFrame()], self.x + self.width / 2, self.y, 0, -1, 1)
        end
    end


end