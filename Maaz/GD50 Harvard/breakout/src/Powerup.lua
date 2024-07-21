Powerup = Class{__includes = Ball}

function Powerup:init(x, y)
    Ball.init(self)
    self.x = x
    self.y = y

    -- total of 10 powerup quads, choosing one at random
    self.skin = math.random(10)

    self.dy = math.random(80, 120)
end

function Powerup:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Powerup:render()
    love.graphics.draw(gTextures['main'], gFrames['powerup'][self.skin],
        self.x, self.y)
end

