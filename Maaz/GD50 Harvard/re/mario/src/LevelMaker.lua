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

    -- to avoid player falling into the chasm at the start of the game
    local landingTileX = nil

    -- flags to check if key and the lock have been spawned which will allow the player 
    -- to advance to the next level
    local keySpawned = false
    local lockSpawned = false

    -- the key will spawn somewhere in the middle of the level
    -- multiplying by the TILE_SIZE to get the x-coordinate of the Love2D world
    local keySpawnTile = math.random(80, width)
    local keySpawnX = (keySpawnTile - 1) * TILE_SIZE 

    local lockSpawnTile = math.random(-5, width)

    local lockframe = nil

    local lockRef = nil
    local currentLevelWidth = width

    local flagframe = math.random(#FLAGS) - 1

    local flagpost = GameObject {
        texture = 'flags-posts',
        flag = 'flags',
        x = (width - 1) * TILE_SIZE,
        y = 3 * TILE_SIZE,
        width = 16,
        height = 48,

        -- make it a random variant
        frame = math.random(#POSTS),
        collidable = false,
        consumable = false,
        show = false,
        hit = false,
        solid = false,
        -- collision function takes itself
        onCollide = function(obj)
            -- spawn a gem if we haven't already hit the block
            if not obj.hit then
                -- chance to spawn gem, not guaranteed
                obj.hit = true
            end
        end,

        onConsume = function(player, obj)
            gSounds['newlevel']:play()
            newLevel = {width = math.floor(currentLevelWidth * LEVELUP_FACT), height = 10, score = player.score,  levelNumber = player.levelNumber + 1}
            gStateMachine:change('play', newLevel)
        end,

        animation = Animation {
            frames = {flagframe * 3 + 1, flagframe * 3 + 2, flagframe * 3 + 3},
            interval = 3.2
        }
    }

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))

            if x == width then
                table.insert(objects, flagpost)
            end
        end

        -- chance to just be emptiness
        if math.random(7) == 1 and x < width then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            if landingTileX == nil then
                landingTileX = x
            end

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 and x < width then
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
                        collidable = false
                    }
                )
            end

            if not lockSpawned and x >= lockSpawnTile then
                lockSpawned = true
                
                lockframe = math.random(4) + 4
                local lockblock = GameObject {
                    texture = 'keys-locks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,

                    frame = lockframe,
                    collidable = true,
                    consumable = true,
                    solid = true,
                    hit = false,

                    -- collision function takes itself
                    onCollide = function(obj)
                        if not obj.hit then
                            obj.hit = true
                        end
                    end,

                    onConsume = function(player, object)
                        gSounds['explode-lock']:play()
                        player.score = player.score + 100

                        if object and object.refOther then
                            object.refOther.consumable = true
                            object.refOther.show = true
                        end
                    end,

                    refOther = flagpost
                }
                lockRef = lockblock
                table.insert(objects, lockblock)

                goto continue
            end
            -- spawn a key somewhere around the middle of the screen offset by some tiles
            if lockSpawned and not keySpawned and x >= keySpawnTile then
                -- set keySpawned flag, to ensure only one key is spawned per level.
                keySpawned = true
                -- getting a reference to the key texture, so that the corresponding lock-block of the same color/texture can be selected
                keyframe = math.random(#KEYS)

                local key = GameObject {
                    texture = 'keys-locks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE - 4,
                    width = 16,
                    height = 16,

                    -- In keys_and_locks.png, keys and corresponding locks are stacked, 
                    -- so subtracting 4 from the lockframe selects the matching key frame
                    frame = lockframe - 4,
                    collidable = true,
                    consumable = true,
                    solid = false,
                    refOther = lockRef,

                    onConsume = function(player, object)
                        gSounds['pickup-key']:play()
                        player.score = player.score + 100
                        -- setting the key attribute in the player, so that it can render to the HUD that the key 
                        -- has been acquired
                        player.key = {texture = object.texture, frame = object.frame}

                        if object and object.refOther then
                            object.refOther.solid = false
                        end

                    end

                    -- reference to the lock block, so that it can set its solid state to false, and make the lock consumable
                }
                table.insert(objects, key)
                
                goto continue
            end


            -- chance to spawn a block
            if math.random(10) == 1 and x < width then
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
            end
        end
        ::continue::
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map, landingTileX)
end