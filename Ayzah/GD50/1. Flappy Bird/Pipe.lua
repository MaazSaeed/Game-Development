Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

PIPE_SPEED = 60

PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    -- self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 20)
    self.y = y

    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation

end

function Pipe:render()
    -- initial when we weren't using pipe pairs:
    -- love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
    -- in the live demo Colton had written self.x and self.y, nothing more or less

    -- when using pipe pairs:
    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
        -- ^ if top then self.y + PIPE_HEIGHT else self.y
        0, -- rotation
        1, -- x scale
        self.orientation == 'top' and -1 or 1 -- y scale if top then 1 else -1
    )
end

function Pipe:update(dt)

end
