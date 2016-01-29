
local scenes = require 'scene'

vec2 = require 'lux.geom.Vector'


function love.load()
  --scene = scenes.title
  scene = scenes.dungeon
  scene.load()
end

function love.update(dt)
  scene.update(dt)
end

function love.draw()
  scene.draw()
end

