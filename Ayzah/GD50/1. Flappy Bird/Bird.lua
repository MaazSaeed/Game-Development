Bird = Class{}

GRAVITY = 7

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
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
        self.dy = -1
    end

    -- apply velocity to position Y
    self.y = self.y + self.dy
end


function Bird:collides(pipe)
    if ((self.x + 2) + (self.width - 6) >= pipe.x) and (self.x + 4 <= pipe.x + PIPE_WIDTH) then
        if ((self.y + 2) + (self.height - 4) >= pipe.y) and (self.y + 2 <= pipe.y + PIPE_HEIGHT) then
            return true
        end
    end
    return false
end