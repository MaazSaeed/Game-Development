Powerup = Class{__includes = Ball}

function Powerup:init(x, y, isKey)
    Ball.init(self)
    self.x = x
    self.y = y

    -- total of 3 powerup quads, choosing one at random
    -- quads 7, 8, and 9 are for mutliple ball powerups
    self.skin = isKey and 10 or math.random(7, 9)


    

    self.dy = math.random(80, 120)

    self.isKey = isKey
end

function Powerup:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Powerup:render()
    love.graphics.draw(gTextures['main'], gFrames['powerup'][self.skin],
        self.x, self.y)
end

