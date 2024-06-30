function GenerateTileQuads(atlas)
    local tiles = {}

    local x = 0
    local y = 0

    local counter = 1

    for row = 1, 9 do
        for i = 1, 2 do
            tiles[counter] = {}

            for col = 1, 6 do
                table.insert(tiles[counter], love.graphics.newQuad(
                    x, y, 32, 32, atlas:getDimensions()
                ))
                x = x + 32
            end

            counter = counter + 1
        end
        y = y + 32
        x = 0
    end

    return tiles
end

--[[
    Recursive table printing function.
    https://docs.coronalabs.com/tutorial/data/outputTable/index.html
]]
function print_r(t)
    local print_r_cache = {}
    local function sub_print_r(t, indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

function love.graphics.roundedRectangle(mode, x, y, width, height, radius)
    -- draw the main rectangle without the corners
    love.graphics.rectangle(mode, x + radius, y, width - 2 * radius, height)
    love.graphics.rectangle(mode, x, y + radius, radius, height - 2 * radius)
    love.graphics.rectangle(mode, x + width - radius, y + radius, radius, height - 2 * radius)

    -- draw the corners
    love.graphics.arc(mode, x + radius, y + radius, radius, math.pi, 3 * math.pi / 2)
    love.graphics.arc(mode, x + width - radius, y + radius, radius, -math.pi / 2, 0)
    love.graphics.arc(mode, x + radius, y + height - radius, radius, math.pi / 2, math.pi)
    love.graphics.arc(mode, x + width - radius, y + height - radius, radius, 0, math.pi / 2)
end
