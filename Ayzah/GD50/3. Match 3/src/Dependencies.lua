Class = require 'src/lib/class'

push = require 'src/lib/push'

Timer = require 'src/lib/knife.timer'

require 'src/Utils'
require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/BeginGameState'
require 'src/states/GameOverState'
require 'src/states/PlayState'
require 'src/states/StartState'

require 'src/Tile'
require 'src/Board'

gSounds = {
    ['music'] = love.audio.newSource('src/sounds/music3.mp3', 'static'),
    ['select'] = love.audio.newSource('src/sounds/select.wav', 'static'),
    ['error'] = love.audio.newSource('src/sounds/error.wav', 'static'),
    ['match'] = love.audio.newSource('src/sounds/match.wav', 'static'),
    ['clock'] = love.audio.newSource('src/sounds/clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('src/sounds/game-over.wav', 'static'),
    ['next-level'] = love.audio.newSource('src/sounds/next-level.wav', 'static')
}

gTextures = {
    ['main'] = love.graphics.newImage('src/graphics/match3.png'),
    ['background'] = love.graphics.newImage('src/graphics/background.png')
}

gFrames = {
    
    -- divided into sets for each tile type in this game, instead of one large
    -- table of Quads
    ['tiles'] = GenerateTileQuads(gTextures['main'])
}

gFonts = {
    ['small'] = love.graphics.newFont('src/fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('src/fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('src/fonts/font.ttf', 32)
}