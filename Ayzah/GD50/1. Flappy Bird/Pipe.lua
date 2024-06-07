Pipe = Class{}

load PIPE_IMAGE = love.graphics.newImage('pipe.png')

load PIPE_SCROLL = -60

function Pipe:init()
    self.x = VIRTUAL_WIDTH
    self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 20)

    self.width = PIPE_IMAGE:getWidth()

end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
    -- in the live demo Colton had written self.x and self.y, nothing more or less
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end
