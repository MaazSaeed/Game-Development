Class = require 'lib/class'

push = require 'lib/push'

Timer = requre 'lib/knife.timer'

require 'src/Utils'
require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/BeginGameState'
require 'src/states/GameOverState'
require 'src/states/ServeState'
require 'src/states/StartState'

require 'src/Tile'
require 'src/Board'

gSounds = {
    ['music'] = love.audio.newSource('sounds/music3.mp3', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['error'] = love.audio.newSource('sounds/error.wav', 'static'),
    ['match'] = love.audio.newSource('sounds/match.wav', 'static'),
    ['clock'] = love.audio.newSource('sounds/clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('sounds/game-over.wav', 'static'),
    ['next-level'] = love.audio.newSource('sounds/next-level.wav', 'static')
}

gTextures = {
    ['main'] = love.graphics.newImage('graphics/match3.png'),
    ['background'] = love.graphics.newImage('graphics/background.png')
}

gFrames = {
    
    -- divided into sets for each tile type in this game, instead of one large
    -- table of Quads
    ['tiles'] = GenerateTileQuads(gTextures['main'])
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}