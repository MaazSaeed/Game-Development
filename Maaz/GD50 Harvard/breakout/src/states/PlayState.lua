--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]

function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.level = params.level

    self.recoverPoints = 5000
    self.hasKey = params.hasKey or false

    -- give ball random starting velocity
    self.ball[1].dx = math.random(-100, 100)
    self.ball[1].dy = math.random(-100, -50)

    -- if the paddle hsa collected a powerup
    self.amped = false

    self.scoreExp = 1000

    -- play sound when key has been collected
    self.keySet = false
end

function PlayState:update(dt)

    if self.score >= self.scoreExp and self.paddle.size <= 3 then
        gSounds['paddle-ampup']:play()
        self.paddle.size = self.paddle.size + 1
        self.scoreExp = self.scoreExp * 2.5
    end

    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)
    --self.ball:update(dt)
    for k, ball in ipairs(self.ball) do
        ball:update(dt)
    end

    for k, ball in ipairs(self.ball) do
        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            
            -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end

            gSounds['paddle-hit']:play()
        end
    end


    for k, ball in ipairs(self.ball) do
    -- detect collision across all bricks with the ball
        for k, brick in pairs(self.bricks) do

            -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick) then

                -- add to score
                if self.hasKey and brick.lockedBrick then
                    brick.lockedBrick = false
                    gSounds['hooray']:play()
                end
                
                if brick.lockedBrick and not self.hasKey then
                    goto continue
                end
                
                brick:hit()
                self.score = self.score + (brick.tier * 200 + brick.color * 25)

                -- trigger the brick's hit function, which removes it from play

                -- if we have enough points, recover a point of health
                if self.score > self.recoverPoints then
                    -- can't go above 3 health
                    self.health = math.min(3, self.health + 1)

                    -- multiply recover points by 2
                    self.recoverPoints = self.recoverPoints + math.min(100000, self.recoverPoints * 2)

                    -- play recover sound effect
                    gSounds['recover']:play()
                end

                -- go to our victory screen if there are no more bricks left
                if self:checkVictory() then
                    gSounds['victory']:play()

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        ball = self.ball,
                        recoverPoints = self.recoverPoints

                    })
                end

                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif ball.y < brick.y then
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                break
            end
            ::continue::
        end
    end

    -- if ball goes below bounds, revert to serve state and decrease health
    for k, ball in ipairs(self.ball) do
        if k == 1 and ball.y >= VIRTUAL_HEIGHT then
            self.health = self.health - 1
            gSounds['hurt']:play()

            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score,
                    highScores = self.highScores
                })
            else
                gStateMachine:change('serve', {
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    level = self.level,
                    recoverPoints = self.recoverPoints,
                    hasKey = self.hasKey,
                    keySet = false
                })
            end
        elseif k ~= 1 and ball.y >= VIRTUAL_HEIGHT then
            -- if the ball is not the main ball which has the id of 1 then it should bounce off the bottom edge of the screen
            ball.dy = -ball.dy
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    for k, brick in pairs(self.bricks) do
        
        -- check to see if a particular brick has a power up, then descend it down (after the brick is destroyed)
        -- and if the paddle collides with the powerup then generate two new balls on the screen
        -- which should have the same properties as the main ball, but shall not result in a loss, if any of the ball
        -- falls down the screen

        if brick.powerup and not brick.inPlay then
            brick.powerup:update(dt)

            if brick.powerup:collides(self.paddle) then
                self.amped = true
                local newBall = Ball()
                newBall.x = self.ball[1].x + math.random(-10, -15)
                newBall.y = self.ball[1].y + math.random(-10, -15)
                newBall.skin = math.random(7)
                newBall.dx = self.ball[1].dx + math.random(-10, -25)
                newBall.dy = self.ball[1].dy + math.random(-10, -25)
                table.insert(self.ball, newBall)
                
                gSounds['powerup']:play()
                
                if brick.powerup and brick.powerup.isKey then
                    self.hasKey = true
                    gSounds['unlocked']:play() -- key attained
                end
                
                brick.powerup = nil
            end
        end
    end


    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
        if brick.powerup and not brick.inPlay then
            brick.powerup:render()
        end
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    for k, ball in ipairs(self.ball) do
        ball:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end

    if self.hasKey then
        love.graphics.draw(gTextures['powerups'], gFrames['powerup'][10], VIRTUAL_WIDTH - 115, 3, 0, 0.6, 0.59)
        if not self.keySet then
            gSounds['keypick']:play()
            self.keySet = true
        end
    end

end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end