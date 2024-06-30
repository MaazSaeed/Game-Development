Tile = Class{}

function Tile:init(x, y, color, variety, shiny)
    -- board positions
    self.gridX = x
    self.gridY = y 

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32
    
    self.shiny = shiny

    self.color = color
    self.variety = variety

end

function Tile:render(x, y)
    -- draw tile shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)

    if self.shiny then
        love.graphics.setColor(1, 1, 1, 0.2) 
        love.graphics.roundedRectangle("fill", self.x + x, self.y + y, 32, 32, 6)
    end
        
end