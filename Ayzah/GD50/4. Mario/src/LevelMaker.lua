--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)
    local landingSpotX = nil
    
    local lockblocks = math.random(width - 30, width - 10)

    local keySpawned = false
    local blockSpawned = false
    local color = nil
    local keyref = nil
    local blockref = nil

    local keyframe = 1

    local keyArray = {color = false, false, false, false}

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- Goals defined
    local goalpost

    goalpost = GameObject {
        texture = 'goal-post',
        x = (width - 1) * TILE_SIZE,
        y = (4 - 1) * TILE_SIZE,
        width = 16,
        height = 16,
        show = false,
        -- make the damn goal post
        frame = 1,
        collidable = false,
        consumable = false,
        solid = false,
        onCollide = function(obj)

            -- carrying the key
            if not obj.hit then
                gSounds['powerup-reveal']:play()
                obj.hit = true
                obj.consumable = true
                obj.collidable = false
                --goalpost.consumable = true
            end
            
            gSounds['empty-block']:play()
        end
    }

    table.insert(objects, goalpost)

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 and x ~= width then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND
            
            if landingSpotX == nil then 
                landingSpotX = x
            end

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            show = true,

                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false,
                        show = true
                    }
                )
            end

            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,
                        show = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,
                                        show = true,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                ) 
                -- Key Code
                elseif not keySpawned and x >= math.random(200, width / 2) then
                keySpawned = true
                keyref = GameObject {
                    texture = 'lock-blocks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    id = 'key',
                    block = nil,
                    -- make it a random variant
                    frame = math.random(4),
                    color = frame,
                    collidable = false,
                    consumable = true,
                    hit = false,
                    solid = false,
                    show = true,

                    -- Consume function takes itself
                    onConsume = function(obj)

                        -- carrying the key
                        if not obj.hit then
                            gSounds['powerup-reveal']:play()
                            obj.hit = true
                            obj.haskey = true
                            keyArray['color'] = true
                        end
                        
                        gSounds['empty-block']:play()
                    end
                }

                table.insert(objects, keyref)
            elseif keySpawned and x >= math.random(50 + width / 2, width - 50) and not blockSpawned then
                blockSpawned = true

                blockref = GameObject {
                    texture = 'lock-blocks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    id = 'lock-block',

                    -- make it a random variant
                    frame = keyref.frame + 4,
                    color = frame,
                    collidable = true,
                    consumable = false,
                    hit = false,
                    solid = true,
                    show = true,

                    -- Consume function takes itself
                    onCollide = function(obj)

                        -- carrying the key
                        if not obj.hit then
                            gSounds['powerup-reveal']:play()
                            obj.hit = true
                            obj.consumable = true
                            obj.collidable = false
                            obj.solid = false
                            goalpost.show = true
                            goalpost.collidable = true
                            goalpost.solid = true
                            --goalpost.consumable = true
                        end
                        
                        gSounds['empty-block']:play()
                    end,

                    onConsume = function(obj)

                        -- carrying the key
                        if not obj.hit then
                            gSounds['powerup-reveal']:play()
                            obj.hit = true
                            goalpost.show = true
                        end
                        
                        gSounds['empty-block']:play()
                    end

                }
                keyref.block = blockref
                table.insert(objects, blockref)

            end

        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map, landingSpotX)
end