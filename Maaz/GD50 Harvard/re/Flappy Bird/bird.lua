Bird = Class{}

local GRAVITY = 9.81
local THRUST = -2

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 + (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 + (self.height / 2)

    self.dy = 0
end


function Bird:update(dt)
    -- Acceleration affects velocity which affects speed which affects position
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = THRUST
    end

    self.y = math.max(0, self.y + self.dy)
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end
