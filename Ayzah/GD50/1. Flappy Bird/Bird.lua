Bird = Class{}

GRAVITY = 15

function Bird:init()
    self.image = love.graphics.newImage('bird2.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    -- apply gravity to velocity
    self.dy = self.dy + GRAVITY*dt

    if love.keyboard.wasPressed('space') then
        self.dy = -5
    end

    -- apply velocity to position Y
    self.y = self.y + self.dy
end