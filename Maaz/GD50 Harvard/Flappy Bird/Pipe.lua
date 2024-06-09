Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

local PIPE_SCROLL = -60

local OFFSET = 20

PIPE_HEIGHT = 60
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH + OFFSET
    self.y = y

    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_IMAGE:getHeight()

    self.orientation = orientation
end


function Pipe:update(dt)
    -- self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, 
    (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
    0, -- rotation
    1, -- X scale
    self.orientation == 'top' and -1 or 1) -- Y scale
    -- -1 as scale value flips the sprite effectively at that particular axis

end
