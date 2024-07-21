Powerup = Class{}

function Powerup:init(x, y)
    self.x = x
    self.y = y

    -- total of 10 powerup quads, choosing one at random
    self.skin = math.random(10)

    self.display = true

    self.dx = 0
    self.dy = math.random(30, 60)

end

function Powerup:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Powerup:render()
    if self.display then
        love.graphics.draw(gTextures['main'], gFrames['powerup'][self.skin],
        self.x, self.y)
    end
end
