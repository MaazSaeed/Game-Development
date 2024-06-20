LevelMaker = Class{}

function LevelMaker.createMap(level)
    local bricks = {}
    local numRows = math.random(1, 5)
    local numCols = math.random(7, 13)

    for y = 1, numRows do
        for x = 1, numCols do
            b = Brick(
                -- x coordinate
                (x - 1) -- tables are 1-indexed, coords are 0
                * 32 -- brick width
                + 8 -- screen should have 8 pixels for padding
                + (13 - numCols) * 16,
                -- y coordinate
                y * 16 -- need top padding
            )
            table.insert(bricks, b)
        end
    end

    return bricks
end