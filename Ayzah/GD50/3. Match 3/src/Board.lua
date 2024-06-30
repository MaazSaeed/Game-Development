--[[
    2. Ensure Level 1 starts just with simple flat blocks (the first of each color in the sprite sheet), 
    with only later levels generating the blocks with patterns on them (like the triangle, cross, etc.). 
    These should be worth more points, at your discretion. This one will be a little trickier than the last step 
    (but only slightly); right now, random colors and varieties are chosen in Board:initializeTiles, but perhaps 
    we could pass in the level variable from the PlayState when a Board is created (specifically in PlayState:enter), 
    and then let that influence what variety is chosen?

    3. Create random shiny versions of blocks that will destroy an entire row on match, granting points for each 
    block in the row. This one will require a little more work! We’ll need to modify the Tile class most likely to 
    hold some kind of flag to let us know whether it’s shiny and then test for its presence in Board:calculateMatches! 
    Shiny blocks, note, should not be their own unique entity, but should be “special” versions of the colors already 
    in the game that override the basic rules of what happens when you match three of that color.

    4. Only allow swapping when it results in a match. If there are no matches available to perform, reset the board. 
    There are multiple ways to try and tackle this problem; choose whatever way you think is best! The simplest is 
    probably just to try and test for Board:calculateMatches after a swap and just revert back if there is no match! 
    The harder part is ensuring that potential matches exist; for this, the simplest way is most likely to pretend swap 
    everything left, right, up, and down, using essentially the same reverting code as just above! However, be mindful 
    that the current implementation uses all of the blocks in the sprite sheet, which mathematically makes it highly 
    unlikely we’ll get a board with any viable matches in the first place; in order to fix this, be sure to instead 
    only choose a subset of tile colors to spawn in the Board (8 seems like a good number, though tweak to taste!) 
    before implementing this algorithm!

]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.level = level
    self.matches = {}

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    maxVariety = math.min(self.level, 6)  -- Ensure maxVariety is between 1 and 6

    for tileY = 1, 8 do
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            local shiny = math.random(1, 10) == 1
            local variety = math.random(1, maxVariety)  -- Set variety based on the level
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(8), variety, shiny))
        end
    end

    while self:calculateMatches() do
        self:initializeTiles() -- in case the initialized board already has matches
    end
end

function Board:calculateMatches()
    local matches = {}
    local shiny_bool = false

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        local matchNum = 1

        for x = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                if matchNum >= 3 then
                    local match = {}

                    for x2 = x - 1, x - matchNum, -1 do
                        table.insert(match, self.tiles[y][x2])
                    end

                    if self:containsShiny(match) then
                        match = {}
                        for col = 1, 8 do
                            table.insert(match, self.tiles[y][col])
                        end
                    end

                    table.insert(matches, match)
                end

                colorToMatch = self.tiles[y][x].color
                matchNum = 1

                if x >= 7 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}

            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end

            if self:containsShiny(match) then
                match = {}
                for col = 1, 8 do
                    table.insert(match, self.tiles[y][col])
                end
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        local matchNum = 1

        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                    end
                    
                    if self:containsShiny(match) then
                        match = {}
                        for row = 1, 8 do
                            table.insert(match, self.tiles[row][x])
                        end
                    end

                    table.insert(matches, match)
                end

                colorToMatch = self.tiles[y][x].color
                matchNum = 1

                if y >= 7 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}

            for y = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end

            if self:containsShiny(match) then
                match = {}
                for row = 1, 8 do
                    table.insert(match, self.tiles[row][x])
                end
            end

            table.insert(matches, match)
        end
    end

    self.matches = matches

    return #self.matches > 0 and self.matches or false
end

function Board:calculatePoints()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            points = 50 *self.tiles[tile.gridY][tile.gridX].variety
        end
    end
    return points
end

function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end
    self.matches = nil
end

function Board:getFallingTiles()
    local tweens = {}

    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8

        while y >= 1 do
            local tile = self.tiles[y][x]

            if space then
                if tile then
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY
                    self.tiles[y][x] = nil

                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    space = false
                    y = spaceY
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

    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            if not tile then
                local shiny = math.random(1, 10) == 1
                local variety = math.random(1, maxVariety)  -- Ensure new tiles follow the level variety rule
                local tile = Tile(x, y, math.random(8), variety, shiny)
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

function Board:containsShiny(match)
    for k, tile in pairs(match) do
        if tile.shiny then
            return true
        end
    end
    return false
end
