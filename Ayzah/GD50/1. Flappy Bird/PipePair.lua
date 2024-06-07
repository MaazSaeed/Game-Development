PipePair = Class{}

local GAP_HEIGHT = 90 -- a comfortable gap between top and bottom pipes

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH -- spawns right outside the screen

    self.y = y

    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT) 
        -- lower: needs to be shifted down by the height of the pipe above and the gap that needs to be between the two
    }

    self.remove = false -- in case the pair is not accidentally removed
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then -- -PIPE_WIDTH because we want the right part of the pipe to be out too
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x -- makes changes to the x of the pipes objects
        self.pipes['upper'].x = self.x
    else
        self.remove = true -- remove if outside the screen
    end
end