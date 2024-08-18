--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety, shiny)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety

    self.shiny = shiny or false

    self.opacity = 255
    self.r = 34
    self.g = 32
    self.b = 52

    self.shineShader = love.graphics.newShader([[
        extern vec2 lightDir;
        extern number shineStrength;
        
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            vec4 pixel = Texel(texture, texture_coords);
            
            // Compute the dot product between the light direction and texture coordinates
            float lightFactor = dot(normalize(lightDir), normalize(texture_coords - vec2(0.5, 0.5)));
            
            // Add the shine effect
            pixel.rgb += shineStrength * max(lightFactor, 0.0) * vec3(0.6, 0.1, 0.0);
            
            return pixel * color;
        }
    ]])

    self.shineStrength = 0.1

end

function Tile:render(x, y)
    -- draw shadow
    love.graphics.setColor(self.r, self.g, self.b, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
    self.x + x + 2, self.y + y + 2)
    
    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)

    if self.shiny then
        self.shineShader:send("lightDir", {0.5, -0.5})  -- Example direction
        self.shineShader:send("shineStrength", 0.1)  -- Adjust the shine strength
        love.graphics.setShader(self.shineShader)

        self.shineStrength = self.shineStrength + 0.001
        if self.shineStrength >= 1.0 then
            self.shineStrength = 0.1
        end
    end

    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)

    if self.shiny then
        love.graphics.setShader()
    end
end