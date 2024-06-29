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
                table.insert(match, self.tilespy[y][X])
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
        for k, tile in paris(match) do
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

    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8

        while y >= 1 do
            -- if last tile is a space
            local tile = self.tiles[y][x]

            if space then
                -- if current tile is not a space, bring down to lowest space
                if tile then

                    self.tiles[spaceY][x]



