PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init(score)
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0 or score

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end


function PlayState:update(dt)
    self.timer = self.timer + dt

    if self.timer > 3 then
        -- copied the comments as they were
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-40, 40), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        
        self.lastY = y

        table.insert(self.pipePairs, PipePair(y))
        
        self.timer = 0
    end

    
    for k, pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end
        pair:update(dt)
    end

    -- Previously:
        -- pipe is outside the left side of the screen
        -- if pipe.x < -pipe.width then
        --     table.remove(pipes, k)
        -- end

        -- Now:
        -- separating this from the previous to ensure zero data dependency
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end


    self.bird:update(dt)
    
    -- collision detectiton
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
            sounds['explosion']:play()
            sounds['hurt']:play()
            gStateMachine:change('score', {
                score = self.score
            })
            end
        end
    end

    -- collision with ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()
        gStateMachine:change('score', 
    {score = self.score})
    end
    
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end
    
    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end