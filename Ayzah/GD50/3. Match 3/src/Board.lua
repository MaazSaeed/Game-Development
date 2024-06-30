Board = Class{}

function Board:init(x, y)
    self.x = x
    self.y = y
    self.match = {}

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do
        -- initialize empty table
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            -- create new tile at X, Y with random colour and variety
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(18), math.random(6)))
        end
    end

    while self:calculateMatches() do
        self.initializeTiles() -- in case the initialized board already 
    end
end

function Board:calculateMatches()
    local matches = {}
    local matches = {}

    local matchNum = 1

    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
        for x = 2, 8 do
            -- colour match
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                -- different color
                colorToMatch = self.tiles[y][x].color

                -- if there are sufficient matches, add each tile to the match that's in that match
                if matchNum >= 3 then
                    local match = {}

                    for x2 = x - 1, x - matchNum, -1 do
                        table.insert(match, self.tiles[y][x2])
                    end
                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't check last two if the colour has been changed
                if x >= 7 then
                    break
                end
            end
        end

        -- in case the latest colour is the same, keep checking till the end
        -- by using a backwards approach
        if matchNum >= 3 then
            local match = {}

            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end
            table.insert(matches, match)
        end
    end

    --vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >=3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                if y >=7 then
                    break
                end
            end
        end

        -- in case the ending also has matching tiles
        if matchNum >=3 then
            local match = {}

            for y = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][X])
            end

            table.insert(matches, match)
        end 
    end

    self.matches = matches

    return #self.matches > 0 and self.matches or false
end


--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end
    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    local tweens = {}

--[[
If a Space is Encountered (space is true):
If the current tile is not nil (if tile then), it means we have a tile above the space.
Move the tile down to the empty space (self.tiles[spaceY][x] = tile), update its gridY 
property (tile.gridY = spaceY), and set the original position to nil (self.tiles[y][x] = nil).
Add a tween animation to move the tile to its new position (tweens[tile] = { y = (tile.gridY - 1) * 32 }).
Reset the space flag and set y to spaceY to continue checking for spaces from the new position.
If No Space is Encountered (space is false):
If the current tile is nil, set the space flag to true and record the spaceY position.
]]

    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8

        while y >= 1 do
            -- if last tile is a space
            local tile = self.tiles[y][x]

            if space then
                -- if current tile is not a space, bring down to lowest space
                if tile then -- means we have a tile above the space

                    -- move down the tile and update grid
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set original position set to nil
                    self.tiles[y][x] = nil

                    -- tween from previous position to new one
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- reset the space flag and set y to spaceY 
                    -- to continue checking for spaces from the new position
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
                
            elseif tile == nil then
                space = true

                
                if spaceY == 0 then
                    spaceY = y
                end

            end

            y = y - 1
        end
    end


--[[
After ensuring all existing tiles have fallen into place, the function iterates over each column again.
For each position in the column, if the tile is nil, it means there's an empty space that needs to be filled with a new tile.
A new tile is created with a random color and variety, initially positioned above the board (tile.y = -32).
The new tile is placed in the board (self.tiles[y][x] = tile), and a tween animation is added to make it fall into place 
(tweens[tile] = { y = (tile.gridY - 1) * 32 }).
]]

for x = 1, 8 do
    for y = 8, 1, -1 do
        local tile = self.tiles[y][x]

        if not tile then

            local tile = Tile(x, y, math.random(18), math.random(6))
            tile.y = -32
            self.tiles[y][x] = tile

            tweens[tile] = {
                y = (tile.gridY - 1) * 32
                }
            end
        end
    end
    return tweens
end



function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end